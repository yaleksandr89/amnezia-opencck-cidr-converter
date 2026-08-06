# Uso avanzado

## Elija un idioma

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](./advanced-usage.md) | [English](./advanced-usage_en.md) | **Seleccionado** | [中文](./advanced-usage_zh.md) | [Français](./advanced-usage_fr.md) | [Deutsch](./advanced-usage_de.md) |

Esta guía reúne los parámetros de ejecución, la selección manual del idioma, la ejecución directa del código fuente, la estructura del proyecto y los comandos de desarrollo.

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
│   └── convert-opencck-cidr.sh
├── tests/
│   ├── fixtures/
│   │   ├── expected-output.json
│   │   └── opencck-sample.json
│   ├── run-tests.ps1
│   └── run-tests.sh
├── docs/
│   ├── contributing/
│   ├── guides/
│   ├── readme/
│   └── security/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── workflows/
│   ├── CONTRIBUTING.md
│   ├── FUNDING.yml
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── SECURITY.md
├── .editorconfig
├── .gitattributes
├── .gitignore
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
chmod +x ./tests/run-tests.sh
./tests/run-tests.sh
```

GitHub Actions ejecuta pruebas nativas por separado en Windows, Ubuntu y macOS.

Las reglas de contribución están en [CONTRIBUTING.md](../contributing/CONTRIBUTING_es.md).
