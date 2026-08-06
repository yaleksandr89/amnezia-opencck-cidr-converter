# Amnezia OpenCCK CIDR Converter

[![CI](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml/badge.svg)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-brightgreen.svg)](../../LICENSE)

## Elija un idioma

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../README.md) | [English](./README_en.md) | **Seleccionado** | [中文](./README_zh.md) | [Français](./README_fr.md) | [Deutsch](./README_de.md) |

Convierte listas IPv4 CIDR de OpenCCK a JSON para importarlas correctamente en AmneziaVPN 5.x.

El proyecto no modifica ni parchea el cliente. Transforma la lista antes de importarla.

> [!IMPORTANT]
> Esta es una solución temporal para un problema de importación CIDR, no un formato oficial de AmneziaVPN. El proyecto no está afiliado con los equipos de AmneziaVPN ni OpenCCK.

## Problema

OpenCCK puede devolver un valor CIDR en el campo `hostname`:

```json
{
  "hostname": "142.250.0.0/15",
  "ip": ""
}
```

Durante una importación problemática puede perderse el prefijo de subred. El convertidor crea una entrada donde el CIDR se guarda en `ip`:

```json
{
  "hostname": "route-000001.invalid",
  "ip": "142.250.0.0/15"
}
```

## Qué hace el convertidor

- acepta una URL generada en `iplist.opencck.org`;
- valida y convierte entradas IPv4 CIDR correctas;
- elimina duplicados conservando el orden original;
- crea `amnezia-opencck-cidr.json` en la raíz del proyecto, listo para importar.

## Sistemas compatibles

| Sistema | Ejecución | Requisitos |
|---|---|---|
| Windows 10/11 | `bin/convert-opencck-cidr.cmd` | Windows PowerShell 5.1 o PowerShell 7 |
| macOS | `bin/convert-opencck-cidr.sh` | Bash y `curl` o `wget` |
| Linux | `bin/convert-opencck-cidr.sh` | Bash y `curl` o `wget` |

## Inicio rápido

### 1. Prepare la URL de OpenCCK

1. Abra [iplist.opencck.org](https://iplist.opencck.org/).
2. Seleccione los sitios y servicios necesarios.
3. Elija el formato **Amnezia**.
4. Elija **rangos IPv4 CIDR**.
5. Desactive **Guardar como archivo**.
6. Copie la URL larga del campo inferior.

### 2. Ejecute el convertidor

#### Windows

Haga doble clic en:

```text
bin/convert-opencck-cidr.cmd
```

#### macOS y Linux

Permita la ejecución una vez:

```bash
chmod +x ./bin/convert-opencck-cidr.sh
```

Ejecute:

```bash
./bin/convert-opencck-cidr.sh
```

El idioma de la interfaz se detecta automáticamente y puede indicarse manualmente al usar parámetros.

Después de finalizar, importe el JSON generado en la aplicación.

Los parámetros, la selección de idioma, la ejecución directa de los fuentes, la estructura del proyecto y las pruebas se describen en la [guía de uso avanzado](../guides/advanced-usage_es.md).

## Limitaciones

- Solo se admite IPv4 CIDR (`data=cidr4`).
- Las descargas de red solo aceptan URL HTTPS de `iplist.opencck.org`.
- El modo de red depende de la disponibilidad y del formato de respuesta de OpenCCK.
- El convertidor puede dejar de ser necesario cuando se corrija el problema en el cliente oficial.

## Comentarios

- errores reproducibles — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues);
- preguntas e ideas — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

---

<p align="center">
  Si la herramienta le ayudó, marque el repositorio con una estrella para que otros desarrolladores puedan encontrarla. 🤘
</p>
