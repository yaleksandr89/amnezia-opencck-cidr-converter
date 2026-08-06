# Seguridad

## Elija un idioma

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/SECURITY.md) | [English](./SECURITY_en.md) | **Seleccionado** | [中文](./SECURITY_zh.md) | [Français](./SECURITY_fr.md) | [Deutsch](./SECURITY_de.md) |

Este es un proyecto pequeño mantenido por una sola persona. Si encuentra un problema de seguridad, notifíquelo sin publicar los detalles antes de que exista una corrección.

## Qué conviene comunicar de forma privada

- ejecución de comandos arbitrarios mediante una URL, una ruta o un argumento;
- omisión de la validación HTTPS o del dominio `iplist.opencck.org`;
- escritura del resultado en una ruta que el usuario no eligió;
- aparición de rutas que no estaban en los datos de entrada;
- manipulación o publicación insegura de un archivo de lanzamiento.

Los errores normales de conversión, las preguntas de uso y las solicitudes de funciones pueden publicarse en [Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues) o [Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

## Cómo informar

Se recomienda GitHub Private Vulnerability Reporting:

1. Abra **Security and quality**.
2. Entre en **Advisories**.
3. Pulse **Report a vulnerability**.
4. Describa el problema sin crear un Issue público.

Si el formulario privado no está disponible, cree un Issue breve sin exploit ni detalles sensibles y solicite un canal de contacto privado.

## Qué incluir

Cuando sea posible, indique:

- versión o commit SHA;
- sistema operativo y entorno de ejecución;
- descripción breve del impacto;
- pasos mínimos de reproducción;
- ejemplo de entrada anonimizado.

No publique claves, tokens, configuraciones privadas ni direcciones de servidores personales.

## Qué ocurrirá después

Intentaré confirmar el informe, reproducir el problema y preparar una corrección. El proyecto no tiene un SLA garantizado ni un programa de recompensas. Conviene coordinar la publicación de los detalles técnicos hasta que exista una corrección.
