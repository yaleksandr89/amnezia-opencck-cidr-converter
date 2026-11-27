# Uso avanzado

## Elija un idioma

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../ru/guides/advanced-usage.md) | [English](../../en/guides/advanced-usage.md) | **Seleccionado** | [中文](../../zh/guides/advanced-usage.md) | [Français](../../fr/guides/advanced-usage.md) | [Deutsch](../../de/guides/advanced-usage.md) |

Esta guía reúne los parámetros de ejecución, la selección manual del idioma, la ejecución directa del código fuente, la estructura del proyecto y los comandos de desarrollo.

## Ejecución desde el código fuente

Clone el repositorio y entre en su raíz. Ejecute los comandos siguientes desde ese directorio.

```bash
git clone https://github.com/yaleksandr89/amnezia-opencck-cidr-converter.git
cd amnezia-opencck-cidr-converter
```

Windows: Windows PowerShell 5.1 (la CLI también admite PowerShell 7). Linux/macOS: Bash, AWK y utilidades estándar; para URL se necesita `curl` o `wget`. Los paquetes incluyen `gum` 0.17.0; la TUI desde el código fuente requiere `gum` en PATH.

## TUI interactiva

Los paquetes listos para usar abren la TUI automáticamente.

La TUI permite elegir la fuente (URL o JSON local), la carpeta de salida y el idioma, repetir la conversión y abrir la carpeta de salida.

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr-ui.ps1
```

Linux/macOS:

```bash
bash ./src/convert-opencck-cidr-ui.sh
```

Elija una ruta de salida distinta del JSON de entrada. Una conversión correcta sustituye el archivo de salida existente. Revise las rutas antes de importarlas.

## Idioma de la interfaz

El modo predeterminado es `auto`:

- Windows usa la cultura actual de la interfaz;
- macOS y Linux usan `LC_ALL`, `LC_MESSAGES` o `LANG`;
- se utiliza inglés cuando no se detecta una configuración regional rusa.

Valores admitidos:

```text
auto
ru
en
```

Windows:

```powershell
.\bin\convert-opencck-cidr.cmd -Language en
```

macOS y Linux:

```bash
./bin/convert-opencck-cidr.sh --language en
```

## Ejecución con parámetros

Las URL de ejemplo están abreviadas: sustituya `https://iplist.opencck.org/?...` por la URL completa de OpenCCK de su navegador.

### Windows

```powershell
.\bin\convert-opencck-cidr.cmd `
  -SourceUrl "https://iplist.opencck.org/?..." `
  -OutputPath ".\routes.json" `
  -Language en
```

JSON local:

```powershell
.\bin\convert-opencck-cidr.cmd `
  -InputPath ".\input.json" `
  -OutputPath ".\routes.json"
```

Parámetros:

| Parámetro | Uso |
|---|---|
| `-SourceUrl` | URL de OpenCCK |
| `-InputPath` | JSON local en formato OpenCCK |
| `-OutputPath` | Ruta del JSON resultante |
| `-Language` | `auto`, `ru` o `en` |
| `-PassThru` | `Success`, `RouteCount`, `OutputPath`, `ErrorMessage` (`src/convert-opencck-cidr.ps1`) |

### macOS y Linux

```bash
./bin/convert-opencck-cidr.sh \
  --source-url 'https://iplist.opencck.org/?...' \
  --output-path './routes.json' \
  --language en
```

JSON local:

```bash
./bin/convert-opencck-cidr.sh \
  --input-path './input.json' \
  --output-path './routes.json'
```

Parámetros:

| Parámetro | Uso |
|---|---|
| `--source-url`, `-u` | URL de OpenCCK |
| `--input-path`, `-i` | JSON local en formato OpenCCK |
| `--output-path`, `-o` | Ruta del JSON resultante |
| `--language`, `-l` | `auto`, `ru` o `en` |
| `--machine-readable` | Salida legible por máquina para TUI e integraciones |
| `--help`, `-h` | Ayuda |

Si no se indica una ruta de salida, el resultado se guarda en la raíz del proyecto:

```text
amnezia-opencck-cidr.json
```

## Ejecución directa del código fuente

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr.ps1 `
  -Language en
```

### macOS y Linux

```bash
bash ./src/convert-opencck-cidr.sh --language en
```

## Estructura del proyecto

```text
.
├── bin/
│   ├── convert-opencck-cidr.cmd
│   └── convert-opencck-cidr.sh
├── src/
│   ├── convert-opencck-cidr.ps1
│   ├── convert-opencck-cidr.sh
│   ├── convert-opencck-cidr-ui.ps1
│   ├── convert-opencck-cidr-ui.sh
│   ├── lib/
│   └── ui/
├── build/
│   ├── windows/
│   └── unix/
├── tests/
├── docs/
│   ├── assets/
│   └── langs/
├── .github/
├── AGENTS.md
├── LICENSE
└── README.md
```

## Desarrollo

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### macOS y Linux

```bash
bash ./tests/run-tests.sh
```

GitHub Actions CI ejecuta pruebas nativas en Windows, Ubuntu y macOS. Las compilaciones se ejecutan por separado: abra [Actions → Standalone](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/standalone.yml), pulse **Run workflow** y seleccione una rama y `targets` (una o varias plataformas o `all`). Para una versión completa, seleccione `master` con CI correcto y `all`. Descargue los archivos de la sección Artifacts de esa ejecución y extraiga los paquetes listos para usar de los ZIP externos. El workflow no publica una versión automáticamente.

Compile en una copia separada: los scripts sustituyen sus directorios y archivos en `dist/` y descargan `gum` verificando SHA-256.

[Licencia de gum (MIT)](../../../../build/windows/third-party/GUM-LICENSE.txt).

[Contribuir](../CONTRIBUTING.md) · [Política de seguridad](../SECURITY.md) · [README](../README.md)
