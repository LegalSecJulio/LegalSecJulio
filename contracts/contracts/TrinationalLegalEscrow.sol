// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title TrinationalLegalEscrow
 * @notice Contrato inteligente de custodia (*escrow*) e intermediación para servicios 
 *         jurídicos y técnico-forenses transfronterizos entre México y Chile.
 * @dev Gestiona fondos en tokens utilitarios, aprobación de entregables y resolución 
 *      de disputas mediante árbitros designados.
 * @author Boutique Cyber Law CDMX / LAINCRIM
 */

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TrinationalLegalEscrow {
    // Estados posibles del ciclo de vida de un acuerdo legal
    enum EscrowStatus { Creado, Fondeado, EnDisputa, Resuelto, Reembolsado }

    struct Agreement {
        address cliente;             // Dirección de la parte contratante (Cliente)
        address proveedor;           // Dirección del prestador del servicio (Boutique Law / LAINCRIM)
        address arbitro;             // Dirección neutral designada para arbitraje
        uint256 monto;               // Monto total en tokens en custodia
        string ipfsContratoLegalHash;// Hash SHA-256 del contrato jurídico firmado en PDF/ODT almacenado en IPFS
        EscrowStatus estado;         // Estado actual del acuerdo
        bool clienteAprobo;          // Indicador de conformidad del cliente
        bool proveedorAprobo;        // Indicador de conformidad del proveedor
    }

    IERC20 public immutable tokenLegal;
    uint256 public totalAcuerdos;
    mapping(uint256 => Agreement) public acuerdos;

    // Eventos de trazabilidad On-Chain
    event AcuerdoCreado(uint256 indexed acuerdoId, address indexed cliente, address indexed proveedor, uint256 monto);
    event EscrowFondeado(uint256 indexed acuerdoId);
    event DisputaIniciada(uint256 indexed acuerdoId, address inicadaPor);
    event DisputaResuelta(uint256 indexed acuerdoId, uint256 montoCliente, uint256 montoProveedor);
    event EscrowCompletado(uint256 indexed acuerdoId);

    // Modificadores de control de acceso y estado
    modifier soloArbitro(uint256 _acuerdoId) {
        require(msg.sender == acuerdos[_acuerdoId].arbitro, "Acceso denegado: Se requiere la direccion del arbitro designado");
        _;
    }

    modifier enEstado(uint256 _acuerdoId, EscrowStatus _estadoEsperado) {
        require(acuerdos[_acuerdoId].estado == _estadoEsperado, "Operacion invalida para el estado actual del acuerdo");
        _;
    }

    constructor(address _direccionToken) {
        require(_direccionToken != address(0), "Direccion de token invalida");
        tokenLegal = IERC20(_direccionToken);
    }

    /**
     * @notice Registra un nuevo acuerdo de servicios jurídicos o peritaje en el contrato.
     * @param _proveedor Dirección de la firma proveedora del servicio.
     * @param _arbitro Dirección del árbitro para resolución de controversias.
     * @param _monto Cantidad de tokens requeridos para el servicio.
     * @param _ipfsContratoLegalHash Hash de integridad del contrato legal firmado fuera de cadena.
     */
    function crearAcuerdo(
        address _proveedor,
        address _arbitro,
        uint256 _monto,
        string calldata _ipfsContratoLegalHash
    ) external returns (uint256) {
        require(_proveedor != address(0) && _arbitro != address(0), "Direcciones de partes invalidas");
        require(_monto > 0, "El monto debe ser mayor a cero");

        totalAcuerdos++;
        acuerdos[totalAcuerdos] = Agreement({
            cliente: msg.sender,
            proveedor: _proveedor,
            arbitro: _arbitro,
            monto: _monto,
            ipfsContratoLegalHash: _ipfsContratoLegalHash,
            estado: EscrowStatus.Creado,
            clienteAprobo: false,
            proveedorAprobo: false
        });

        emit AcuerdoCreado(totalAcuerdos, msg.sender, _proveedor, _monto);
        return totalAcuerdos;
    }

    /**
     * @notice El cliente fondea el acuerdo transfiriendo los tokens al contrato inteligente.
     */
    function fondearEscrow(uint256 _acuerdoId) external enEstado(_acuerdoId, EscrowStatus.Creado) {
        Agreement storage ac = acuerdos[_acuerdoId];
        require(msg.sender == ac.cliente, "Solo el cliente puede fondear el acuerdo");

        ac.estado = EscrowStatus.Fondeado;
        require(tokenLegal.transferFrom(msg.sender, address(this), ac.monto), "Falla en la transferencia de tokens");

        emit EscrowFondeado(_acuerdoId);
    }

    /**
     * @notice Las partes aprueban la liberación de fondos al completarse el entregable pericial/jurídico.
     */
    function aprobarLiberacion(uint256 _acuerdoId) external enEstado(_acuerdoId, EscrowStatus.Fondeado) {
        Agreement storage ac = acuerdos[_acuerdoId];
        require(msg.sender == ac.cliente || msg.sender == ac.proveedor, "Parte no autorizada");

        if (msg.sender == ac.cliente) ac.clienteAprobo = true;
        if (msg.sender == ac.proveedor) ac.proveedorAprobo = true;

        if (ac.clienteAprobo && ac.proveedorAprobo) {
            ac.estado = EscrowStatus.Resuelto;
            require(tokenLegal.transfer(ac.proveedor, ac.monto), "Transferencia al proveedor fallida");
            emit EscrowCompletado(_acuerdoId);
        }
    }

    /**
     * @notice Inicia formalmente un proceso de disputa congelando los fondos hasta el laudo arbitral.
     */
    function levantarDisputa(uint256 _acuerdoId) external enEstado(_acuerdoId, EscrowStatus.Fondeado) {
        Agreement storage ac = acuerdos[_acuerdoId];
        require(msg.sender == ac.cliente || msg.sender == ac.proveedor, "Solo las partes contratantes pueden disputar");

        ac.estado = EscrowStatus.EnDisputa;
        emit DisputaIniciada(_acuerdoId, msg.sender);
    }

    /**
     * @notice El árbitro resuelve la disputa distribuyendo los fondos entre cliente y proveedor según el laudo.
     */
    function resolverDisputa(
        uint256 _acuerdoId,
        uint256 _montoCliente,
        uint256 _montoProveedor
    ) external soloArbitro(_acuerdoId) enEstado(_acuerdoId, EscrowStatus.EnDisputa) {
        Agreement storage ac = acuerdos[_acuerdoId];
        require(_montoCliente + _montoProveedor == ac.monto, "La suma de la distribucion debe igualar el total en escrow");

        ac.estado = EscrowStatus.Resuelto;

        if (_montoCliente > 0) {
            require(tokenLegal.transfer(ac.cliente, _montoCliente), "Transferencia al cliente fallida");
        }
        if (_montoProveedor > 0) {
            require(tokenLegal.transfer(ac.proveedor, _montoProveedor), "Transferencia al proveedor fallida");
        }

        emit DisputaResuelta(_acuerdoId, _montoCliente, _montoProveedor);
    }
}
