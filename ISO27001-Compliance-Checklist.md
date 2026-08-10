# 📋 Checklist Interactivo: Cumplimiento Técnico-Legal ISO/IEC 27001:2022

Esta lista de verificación está diseñada para alinear los requisitos legales de gobernanza corporativa con la infraestructura de ciberseguridad (controles del Anexo A).

---

## ⚖️ Bloque 1: Controles Organizacionales y Legales (Gobernanza)
- [ ] **A.5.11 Políticas para la seguridad de la información:** Revisión y aprobación anual de las políticas de seguridad por parte de la alta dirección.
- [ ] **A.5.20 Seguridad de la información en las relaciones con proveedores:** Inclusión de cláusulas de confidencialidad (NDAs) y auditoría en todos los contratos de servicios tecnológicos.
- [ ] **A.5.34 Privacidad y protección de datos personales:** Validación del cumplimiento de las leyes locales (ej. regulaciones de México y Chile) en el tratamiento de datos de clientes y empleados.
- [ ] **A.5.31 Requisitos legales, estatutarios, reglamentarios y contractuales:** Inventario actualizado de todas las normativas legales aplicables a la organización para evitar sanciones.

---

## 🛡️ Bloque 2: Controles Técnicos (Ciberseguridad e Infraestructura Cisco)
- [ ] **A.8.20 Seguridad en redes:** Implementación de segmentación de redes, listas de control de acceso (ACLs) y bastionado (hardening) en enrutadores y switches Cisco.
- [ ] **A.8.24 Uso de criptografía:** Configuración de cifrado robusto (AES-256) para datos en reposo y en tránsito (ej. forzar SSH y deshabilitar HTTP/Telnet en la línea de comandos).
- [ ] **A.8.16 Registro de eventos (Logging):** Centralización de los logs de auditoría (Syslog) de los dispositivos de red para garantizar la trazabilidad forense.
- [ ] **A.8.22 Gestión de privilegios de acceso:** Control estricto de accesos administrativos mediante protocolos robustos (ej. TACACS+ o RADIUS centralizado en Cisco ISE).

---

## 🚨 Bloque 3: Gestión de Incidentes de Seguridad
- [ ] **A.5.24 Planificación y preparación:** Existencia de un protocolo de respuesta a incidentes que defina claramente los roles técnicos y legales.
- [ ] **A.5.26 Respuesta a incidentes:** Procedimientos establecidos para contener brechas y preservar la cadena de custodia de la evidencia informática.
- [ ] **A.5.28 Recopilación de evidencias:** Métodos forenses validados para extraer información sin alterar los sistemas originales.

---

## ⚠️ Descargo de Responsabilidad (Disclaimer)
Este checklist constituye una guía de referencia simplificada basada en el Anexo A de la norma ISO/IEC 27001:2022. La obtención de una certificación oficial requiere una auditoría exhaustiva por parte de un organismo acreditado. Adapte estos controles a las necesidades operativas y legales de su organización.
