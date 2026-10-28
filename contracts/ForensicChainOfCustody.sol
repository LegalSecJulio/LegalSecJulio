// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title ForensicChainOfCustody
 * @notice Contrato para la notarización descentralizada e inmutable de evidencia digital forense.
 * @dev Implementa un sistema de validación cruzada por nodos regionales (Proof-of-Authority)
 *      para cumplir con criterios de mismidad e integridad probatoria.
 * @author Boutique Cyber Law CDMX / LAINCRIM
 */

contract ForensicChainOfCustody {
    struct EvidenceRecord {
        bytes32 hashEvidencia;     // Hash criptográfico SHA-256 o BLAKE3 de la imagen forense (.E01 / .DD)
        string metadataURI;        // URI IPFS con el informe técnico (ExifTool, perito, cadena de custodia)
        uint256 marcaDeTiempo;     // Estampa de tiempo UNIX del registro inicial
        address peritoPrimario;    // Dirección del nodo perito que registró inicialmente la evidencia
        bool nodoMXValidado;       // Validación por Nodo México (Boutique Cyber Law CDMX)
        bool nodoCLValidado;       // Validación por Nodo Chile (Hyperium IA / LAINCRIM)
    }

    address public nodoMX;
    address public nodoCL;

    mapping(bytes32 => EvidenceRecord) public evidencias;
    bytes32[] public listaEvidencias;

    // Eventos de auditoría forense
    event EvidenciaNotarizada(bytes32 indexed hashEvidencia, address indexed perito, uint256 marcaDeTiempo);
    event NodoValidado(bytes32 indexed hashEvidencia, address indexed validador, string jurisdiccion);

    modifier soloNodosAutorizados() {
        require(msg.sender == nodoMX || msg.sender == nodoCL, "Acceso denegado: El emisor no es un nodo pericial autorizado");
        _;
    }

    constructor(address _nodoMX, address _nodoCL) {
        require(_nodoMX != address(0) && _nodoCL != address(0), "Direcciones de nodos invalidas");
        nodoMX = _nodoMX;
        nodoCL = _nodoCL;
    }

    /**
     * @notice Registra y notariza una nueva evidencia digital forense en la blockchain.
     * @param _hashEvidencia Hash SHA-256 único del archivo o contenedor forense.
     * @param _metadataURI Enlace IPFS conteniendo la documentación pericial detallada.
     */
    function registrarEvidencia(
        bytes32 _hashEvidencia,
        string calldata _metadataURI
    ) external soloNodosAutorizados {
        require(evidencias[_hashEvidencia].marcaDeTiempo == 0, "El hash de evidencia ya se encuentra registrado");

        EvidenceRecord storage registro = evidencias[_hashEvidencia];
        registro.hashEvidencia = _hashEvidencia;
        registro.metadataURI = _metadataURI;
        registro.marcaDeTiempo = block.timestamp;
        registro.peritoPrimario = msg.sender;

        if (msg.sender == nodoMX) registro.nodoMXValidado = true;
        if (msg.sender == nodoCL) registro.nodoCLValidado = true;

        listaEvidencias.push(_hashEvidencia);
        emit EvidenciaNotarizada(_hashEvidencia, msg.sender, block.timestamp);
    }

    /**
     * @notice Permite al nodo binario contraparte verificar y validar la evidencia existente.
     * @param _hashEvidencia Hash de la evidencia a refrendar.
     */
    function validarEvidencia(bytes32 _hashEvidencia) external soloNodosAutorizados {
        require(evidencias[_hashEvidencia].marcaDeTiempo > 0, "El registro de evidencia no existe");

        EvidenceRecord storage registro = evidencias[_hashEvidencia];
        string memory jurisdiccion;

        if (msg.sender == nodoMX) {
            registro.nodoMXValidado = true;
            jurisdiction = "MX";
        } else if (msg.sender == nodoCL) {
            registro.nodoCLValidado = true;
            jurisdiction = "CL";
        }

        emit NodoValidado(_hashEvidencia, msg.sender, jurisdiction);
    }

    /**
     * @notice Consulta pública para verificar la integridad, estado y firmas de una evidencia digital.
     */
    function verificarIntegridadEvidencia(bytes32 _hashEvidencia) external view returns (
        bool estaRegistrada,
        uint256 marcaDeTiempo,
        address perito,
        uint8 conteoValidaciones,
        string memory metadata
    ) {
        EvidenceRecord memory registro = evidencias[_hashEvidencia];
        if (registro.marcaDeTiempo == 0) {
            return (false, 0, address(0), 0, "");
        }

        uint8 conteo = 0;
        if (registro.nodoMXValidado) conteo++;
        if (registro.nodoCLValidado) conteo++;

        return (true, registro.marcaDeTiempo, registro.peritoPrimario, conteo, registro.metadataURI);
    }
}
