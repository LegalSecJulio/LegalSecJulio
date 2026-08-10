# 🛡️ Guía de Hardening y Cumplimiento Legal para Enrutadores Cisco

Este documento establece las configuraciones técnicas esenciales para asegurar la infraestructura de red perimetral Cisco, alineada con las exigencias normativas de debida diligencia legal en seguridad de la información.

---

## 🛠️ 1. Configuraciones Técnicas de Seguridad (iOS Baseline)

Para mitigar accesos no autorizados y asegurar el plano de administración, aplique los siguientes comandos en la terminal de configuración:

### Desactivación de Servicios Inseguros
```cos
no ip http server
no ip http secure-server
no ip source-route
```

### Cifrado de Contraseñas locales y Autenticación Fuerte
```cos
service password-encryption
username [admin_user] secret [contraseña_robusta]
```

### Aseguramiento de Líneas de Acceso Virtual (VTY)
```cos
line vty 0 4
 transport input ssh
 exec-timeout 5 0
```

---

## ⚖️ 2. Marco Jurídico: El Banner de Acceso (MOTD)

La configuración del banner de inicio de sesión no es solo un aviso estético; constituye una **pieza de evidencia legal fundamental** en caso de intrusión informática para demostrar que el acceso no autorizado fue advertido explícitamente.

### Comando de Configuración
```cos
banner motd #
************************************************************************
AVISO LEGAL: ACCESO RESTRINGIDO. Este sistema es propiedad privada. 
El acceso no autorizado está estrictamente prohibido y será objeto de 
acciones legales civiles y penales bajo las leyes locales e internacionales.
Toda actividad en esta red es monitoreada y registrada.
************************************************************************
#
```

---

## ⚠️ Descargo de Responsabilidad (Disclaimer)
Las líneas de comando e instrucciones legales provistas en este repositorio tienen fines estrictamente didácticos e ilustrativos. Cualquier implementación en entornos de producción reales de Cisco debe ser previamente validada en laboratorios de prueba por personal certificado y adaptada a la legislación penal informática del territorio correspondiente (México, Chile, etc.).
