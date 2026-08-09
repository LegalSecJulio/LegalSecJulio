# Contrato de Confidencialidad (NDA) para Auditorías de Infraestructura Cisco

Este documento establece los términos de confidencialidad para la revisión, análisis y auditoría técnica de la infraestructura de red, seguridad y telecomunicaciones.

---

## ⚖️ 1. Definición de Información Confidencial
Para efectos de este acuerdo, se considerará información confidencial, de manera enunciativa mas no limitativa:
- Topologías de red, mapas de direccionamiento IP y diagramas de arquitectura.
- Configuraciones de dispositivos (archivos `running-config` y `startup-config` de routers, switches y firewalls Cisco).
- Reportes de análisis de vulnerabilidades, logs de auditoría (Syslog), políticas de Cisco ISE y credenciales de acceso.
- Cualquier dato personal, comercial o estratégico expuesto durante la auditoría.

## 🛡️ 2. Obligaciones Técnicas de Resguardo
El consultor y analista técnico se compromete a:
- Almacenar toda la información recolectada en contenedores cifrados con algoritmos robustos (ej. AES-256).
- No transferir archivos de configuración a través de canales inseguros (se prohíbe el uso de FTP estándar o HTTP plano).
- Restringir el acceso a los datos únicamente al personal técnico autorizado y asignado al proyecto.

## 📆 3. Vigencia y Destrucción de Datos
Las obligaciones de confidencialidad permanecerán vigentes por un periodo de **[X] años** tras la finalización del servicio. Una vez entregado el dictamen final, toda copia de las configuraciones Cisco y mapas de red en posesión del auditor deberá ser borrada mediante métodos de borrado seguro.

---

## ⚠️ Descargo de Responsabilidad (Disclaimer)
El presente modelo se proporciona exclusivamente con fines didácticos e informativos en el perfil profesional de GitHub. No constituye asesoría legal vinculante. Cada organización debe adaptar este clausulado a la legislación local de su país (ej. México, Chile) y a las políticas corporativas específicas de su infraestructura de TI.
