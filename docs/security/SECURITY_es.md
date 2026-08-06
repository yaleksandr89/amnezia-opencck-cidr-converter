# Política de seguridad

## Elija un idioma

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/SECURITY.md) | [English](./SECURITY_en.md) | **Seleccionado** | [中文](./SECURITY_zh.md) | [Français](./SECURITY_fr.md) | [Deutsch](./SECURITY_de.md) |

## Versiones compatibles

Las correcciones de seguridad se publican para la última versión publicada del proyecto.

| Versión | Compatibilidad |
|---|---|
| Última versión | Sí |
| Versiones anteriores | No |

## Qué se considera una vulnerabilidad

Los problemas de seguridad incluyen, entre otros:

- ejecución arbitraria de comandos mediante una URL, una ruta o un argumento de línea de comandos;
- omisión de la validación HTTPS o del dominio `iplist.opencck.org`;
- escritura del resultado en una ubicación inesperada sin una solicitud explícita del usuario;
- tratamiento del contenido de la respuesta de OpenCCK como código ejecutable;
- generación de un resultado que añada silenciosamente rutas ausentes en los datos de entrada;
- manipulación o publicación insegura del archivo de una versión.

Los errores normales de conversión, las preguntas de uso y las solicitudes de funciones pueden publicarse en GitHub Issues o Discussions siempre que no incluyan información sensible.

## Cómo informar de una vulnerabilidad

Se recomienda GitHub Private Vulnerability Reporting cuando esté disponible:

1. Abra **Security and quality**.
2. Vaya a **Advisories**.
3. Seleccione **Report a vulnerability**.
4. Envíe el informe sin publicar los detalles técnicos en un Issue público.

Si los informes privados no están disponibles, cree un Issue público mínimo sin detalles de explotación y solicite un canal de comunicación privado.

No publique:

- un exploit funcional;
- configuraciones privadas de la aplicación;
- claves, contraseñas o tokens;
- direcciones de servidores personales;
- otra información que permita explotar la vulnerabilidad antes de publicar una corrección.

## Contenido del informe

Cuando sea posible, incluya:

- la versión publicada o el commit SHA;
- el sistema operativo y la versión del entorno: PowerShell o Bash;
- una descripción del impacto;
- pasos mínimos de reproducción;
- el comportamiento esperado y el real;
- un ejemplo de entrada anonimizado;
- una posible corrección, si se conoce.

## Gestión del informe

Los informes se confirmarán y revisarán en la medida de lo posible. No se garantiza un SLA fijo.

Coordine la divulgación con el responsable del proyecto antes de publicar los detalles. El proyecto no ofrece un programa de recompensas por vulnerabilidades.
