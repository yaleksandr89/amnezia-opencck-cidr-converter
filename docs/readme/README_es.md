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
> Esta es una solución temporal para un problema de importación de CIDR, no un formato oficial de AmneziaVPN. El proyecto no está afiliado con los equipos de AmneziaVPN ni de OpenCCK.

## Problema

OpenCCK puede devolver un valor CIDR en el campo `hostname`:

```json
{
  "hostname": "142.250.0.0/15",
  "ip": ""
}
```

Durante una importación problemática, el prefijo de subred puede perderse. El convertidor mueve el valor CIDR al campo `ip` y crea un nombre de servicio único:

```json
{
  "hostname": "route-000001.invalid",
  "ip": "142.250.0.0/15"
}
```

La ruta real se guarda en `ip`. El nombre bajo `.invalid` se utiliza únicamente como clave única del registro.

## Qué hace el convertidor

1. Acepta una URL generada en `iplist.opencck.org`.
2. Valida HTTPS, el dominio, el formato `Amnezia` y el tipo de datos `IPv4 CIDR`.
3. Descarga la lista JSON actual.
4. Valida las entradas IPv4 CIDR.
5. Elimina duplicados conservando el orden original.
6. Mueve los valores CIDR de `hostname` a `ip`.
7. Genera nombres secuenciales como `route-000001.invalid`.
8. Guarda el resultado como JSON UTF-8 sin BOM.

Ambas implementaciones también pueden convertir un JSON local para desarrollo y pruebas automatizadas.

## Estructura del proyecto

```text
bin/                   lanzadores para el usuario
src/                   implementaciones nativas para Windows y sistemas Unix
tests/                 pruebas y datos de prueba
docs/readme/           traducciones del README
docs/contributing/     traducciones de la guía de contribución
docs/security/         traducciones de la política de seguridad
.github/               CI, plantillas y archivos comunitarios de GitHub
```

## Sistemas compatibles

| Sistema | Lanzador | Requisitos |
|---|---|---|
| Windows 10/11 | `bin/convert-opencck-cidr.cmd` | Windows PowerShell 5.1 o PowerShell 7 |
| macOS | `bin/convert-opencck-cidr.sh` | Bash y `curl` o `wget` |
| Linux | `bin/convert-opencck-cidr.sh` | Bash y `curl` o `wget` |

No es necesario instalar Python ni PowerShell en macOS o Linux. Windows utiliza PowerShell, mientras que macOS y Linux usan la implementación nativa en Bash.

## Idioma de la interfaz

El convertidor admite interfaces en ruso e inglés.

El valor predeterminado es `auto`:

- Windows utiliza la cultura actual de la interfaz;
- macOS y Linux utilizan `LC_ALL`, `LC_MESSAGES` o `LANG`;
- se utiliza inglés cuando no se detecta una configuración regional rusa.

El idioma también puede indicarse explícitamente.

Windows:

```powershell
.\bin\convert-opencck-cidr.cmd `
  -Language en
```

macOS y Linux:

```bash
./bin/convert-opencck-cidr.sh --language en
```

Valores admitidos: `auto`, `ru`, `en`.

## Inicio rápido

### 1. Prepare una URL de OpenCCK

1. Abra [iplist.opencck.org](https://iplist.opencck.org/).
2. Seleccione los sitios y servicios necesarios.
3. Elija el formato **Amnezia**.
4. Elija **zonas IPv4 CIDR** como tipo de datos.
5. Desactive **Guardar como archivo**.
6. Copie la URL larga del campo situado al final de la página.

### 2. Ejecute el convertidor

#### Windows

Haga doble clic en:

```text
bin/convert-opencck-cidr.cmd
```

O pase los parámetros desde una terminal:

```powershell
.\bin\convert-opencck-cidr.cmd `
  -SourceUrl "https://iplist.opencck.org/?..." `
  -OutputPath ".\routes.json" `
  -Language en
```

#### macOS y Linux

Conceda permiso de ejecución una vez:

```bash
chmod +x ./bin/convert-opencck-cidr.sh
```

Modo interactivo:

```bash
./bin/convert-opencck-cidr.sh
```

O pase los parámetros directamente:

```bash
./bin/convert-opencck-cidr.sh \
  --source-url 'https://iplist.opencck.org/?...' \
  --output-path './routes.json' \
  --language en
```

Si no se especifica una ruta de salida, se crea el siguiente archivo en la raíz del proyecto:

```text
amnezia-opencck-cidr.json
```

Importe el JSON generado en la aplicación.

## Ejecución directa de las implementaciones

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr.ps1 `
  -Language en
```

Parámetros: `-SourceUrl`, `-InputPath`, `-OutputPath`, `-Language`.

### macOS y Linux

```bash
bash ./src/convert-opencck-cidr.sh --language en
```

Parámetros: `--source-url`, `--input-path`, `--output-path`, `--language`.

## Limitaciones

- Solo se admite IPv4 CIDR (`data=cidr4`).
- Las descargas de red solo aceptan URL HTTPS del dominio `iplist.opencck.org`.
- El modo de red depende de la disponibilidad y del formato de respuesta de OpenCCK.
- **El convertidor puede dejar de ser necesario cuando se corrija el problema de importación en el cliente oficial.**

## Desarrollo

### Pruebas en Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### Pruebas en macOS y Linux

```bash
chmod +x ./tests/run-tests.sh
./tests/run-tests.sh
```

GitHub Actions ejecuta pruebas nativas por separado en Windows, Ubuntu y macOS.

Las reglas para contribuir están disponibles en [CONTRIBUTING.md](../contributing/CONTRIBUTING_es.md).

## Comentarios

- errores reproducibles — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues);
- preguntas e ideas — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

---

<p align="center">
  Si esta herramienta le resultó útil, marque el repositorio con una estrella para que otros desarrolladores puedan encontrarlo. 🤘
</p>
