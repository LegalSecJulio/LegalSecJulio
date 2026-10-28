# Aegis Forensic Grid 🛡️⛓️

> **Protocolo binacional descentralizado de notarización forense y arbitraje digital transfronterizo (MX - CL)**

---

## 📌 Resumen Ejecutivo

**Aegis Forensic Grid** es un protocolo de Ciberseguridad y *Legal-Tech* de nivel empresarial diseñado para establecer un puente inmutable y transfronterizo entre **México (CDMX)** y **Chile (Valparaíso/Santiago)**.

El marco integra la notarización criptográfica de evidencias (*Proof-of-Authority*), contratos inteligentes de custodia (*escrow*) automatizados y una capa de gobernanza jurídica binacional. Su objetivo es garantizar la **integridad, la cadena de custodia y la inalterabilidad** de la evidencia digital presentada ante tribunales, proveyendo al mismo tiempo un entorno seguro de pagos para la prestación de servicios periciales y técnico-forenses.

---

## 🏛️ Alianza Estratégica y Nodos Regionales

El protocolo opera bajo un mecanismo de consenso de **Prueba de Autoridad (Proof-of-Authority - PoA)** conformado por dos nodos de validación pericial independientes:

* **Nodo México (Boutique Cyber Law CDMX):** Valida la metadatuación jurídica, criterios de cumplimiento, protección de datos personales (LFPDPPP) y asegura que la evidencia cumpla con los estándares procesales del *Código Nacional de Procedimientos Civiles y Familiares (CNPCyF)* y la norma NMX-I-151-NYCE.
* **Nodo Chile (Hyperium IA / LAINCRIM):** Ejecuta la extracción técnico-forense (`.E01`, `.DD`, extracciones móviles), el cálculo de huellas de integridad (`SHA-256`) y la verificación de firma electrónica avanzada bajo la *Ley N° 19.799 de Chile*.

---

## ⚙️ Arquitectura y Contratos inteligentes (Smart Contracts)

### 1. `ForensicChainOfCustody.sol`
* **Propósito:** Registra y notariza las huellas digitales (*hashes*) de la evidencia forense (*Notarización On-Chain*).
* **Mecánica:** Genera un certificado dinámico y no transferible (bajo estructura de *Soulbound Token*) que almacena el *hash* `SHA-256` del archivo, marcas de tiempo UTC, URIs de metadatos en IPFS y firmas criptográficas de validación cruzada entre ambos nodos.

### 2. `TrinationalLegalEscrow.sol` (Modo operativo binacional)
* **Propósito:** Gestiona los fondos en custodia (tokens de utilidad $AEGIS / $3LB) para auditorías forenses y servicios legales transfronterizos.
* **Mecánica:** Liberación mediante firmas múltiples ($2$-de-$2$ o resolución por árbitro), congelamiento programático ante disputas e integración de cláusulas de jurisdicción aplicable.

---

## ⚖️ Admisibilidad procesal transfronteriza

| Jurisdicción | Marco normativo / Ley aplicable | Valor aportado por Aegis Grid |
| :--- | :--- | :--- |
| **México 🇲🇽** | **CNPCyF** (Art. 268-275) y **Código de Comercio** (Art. 89) | Garantiza la **Autenticidad e Integridad** mediante *hashes* SHA-256 inmutables notarizados en cadena conforme a los lineamientos de la NMX-I-151-NYCE. |
| **Chile 🇨🇱** | **Ley N° 19.799** sobre Documentos Electrónicos y Firma | Otorga equivalencia funcional de Instrumento Público/Privado con sellado de tiempo criptográfico respaldado por el peritaje técnico de LAINCRIM. |

---

## 📄 Licencia y Mantenimiento

Este proyecto se distribuye bajo la **Licencia MIT**.

* **Boutique Cyber Law CDMX** — *Líder en Legal-Tech y Defensa Digital* (Dir. Lic. Julio César Olvera A.)
* **Hyperium IA / LAINCRIM** — *Líder en Ingeniería Forense y Arquitectura de IA* (CEO Patricio Tirado)
