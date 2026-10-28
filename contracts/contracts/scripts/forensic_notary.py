#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
@title Aegis Forensic Grid - Automatizador de notarización forense CLI
@notice Script para calcular huellas digitales SHA-256 e inscribir la cadena 
        de custodia directamente en la red Polygon para validación binacional (MX-CL).
@author Boutique Cyber Law CDMX / LAINCRIM
"""

import hashlib
import sys
import json
import os
from web3 import Web3

# Configuración de Entorno (RPC de Polygon y Credenciales del Nodo)
RPC_URL = os.getenv("POLYGON_RPC_URL", "https://polygon-rpc.com")
LLAVE_PRIVADA_NODO = os.getenv("FORENSIC_NODE_PRIV_KEY")
CONTRATO_DIRECCION = os.getenv("FORENSIC_CONTRACT_ADDRESS")

# ABI simplificado del contrato de Cadena de Custodia Forense
ABI_CONTRATO = json.loads('[{"inputs":[{"internalType":"bytes32","name":"_hashEvidencia","type":"bytes32"},{"internalType":"string","name":"_metadataURI","type":"string"}],"name":"registrarEvidencia","outputs":[],"stateMutability":"nonpayable","type":"function"}]')

def calcular_hash_forense(ruta_archivo: str) -> str:
    """Calcula el hash SHA-256 de un archivo de evidencia por bloques para optimizar memoria."""
    sha256 = hashlib.sha256()
    with open(ruta_archivo, "rb") as archivo:
        for bloque in iter(lambda: archivo.read(65536), b""):
            sha256.update(bloque)
    return sha256.hexdigest()

def notarizar_en_cadena(hash_hex_evidencia: str, uri_metadata: str):
    """Ejecuta la transacción de registro y firma inmutable en la red Polygon."""
    w3 = Web3(Web3.HTTPProvider(RPC_URL))
    if not w3.is_connected():
        print("[!] ERROR CRITICO: No se pudo establecer conexion con el nodo RPC de Polygon.")
        sys.exit(1)

    cuenta = w3.eth.account.from_key(LLAVE_PRIVADA_NODO)
    contrato = w3.eth.contract(address=Web3.to_checksum_address(CONTRATO_DIRECCION), abi=ABI_CONTRATO)

    bytes32_hash = bytes.fromhex(hash_hex_evidencia)
    
    print(f"[*] Iniciando Notarizacion On-Chain para Hash: 0x{hash_hex_evidencia}")
    print(f"[*] Nodo Operador Firmante: {cuenta.address}")

    # Construcción de la transacción
    transaccion = contrato.functions.registrarEvidencia(bytes32_hash, uri_metadata).build_transaction({
        'from': cuenta.address,
        'nonce': w3.eth.get_transaction_count(cuenta.address),
        'gasPrice': w3.eth.gas_price,
    })

    # Firma con la llave privada del nodo pericial
    transaccion_firmada = w3.eth.account.sign_transaction(transaccion, private_key=LLAVE_PRIVADA_NODO)
    hash_tx = w3.eth.send_raw_transaction(transaccion_firmada.rawTransaction)
    
    print(f"[+] Evidencia Notarizada Exitosamente. Hash de Transaccion: {w3.to_hex(hash_tx)}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso correcto: python3 forensic_notary.py <ruta_del_archivo_de_evidencia>")
        sys.exit(1)

    archivo_objetivo = sys.argv[1]
    if not os.path.exists(archivo_objetivo):
        print(f"[!] Error: El archivo de evidencia '{archivo_objetivo}' no existe en la ruta especificada.")
        sys.exit(1)

    print(f"[*] Procesando archivo forense: {archivo_objetivo}")
    hash_calculado = calcular_hash_forense(archivo_objetivo)
    print(f"[+] Hash SHA-256 Calculado con Exito: {hash_calculado}")

    # Generación simulada de URI IPFS para el dictamen metadatuado
    uri_ipfs_simulada = f"ipfs://QmAegisForenseMetadata_{hash_calculado[:10]}"
    
    # Verificación de credenciales antes de enviar a blockchain
    if LLAVE_PRIVADA_NODO and CONTRATO_DIRECCION:
        notarizar_en_cadena(hash_calculado, uri_ipfs_simulada)
    else:
        print("[i] Modo Offline Activo: Variables de entorno no detectadas. Hash listo para integración manual.")

<FollowUp label="¿Deseas que preparemos algún otro script o documento técnico para el repositorio?" query="¿Qué otro componente técnico o jurídico del ecosistema Aegis Forensic Grid deseas estructurar?"/>
