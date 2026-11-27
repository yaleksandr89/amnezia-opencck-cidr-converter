# Advanced usage

## Choose a language

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../ru/guides/advanced-usage.md) | **Selected** | [Español](../../es/guides/advanced-usage.md) | [中文](../../zh/guides/advanced-usage.md) | [Français](../../fr/guides/advanced-usage.md) | [Deutsch](../../de/guides/advanced-usage.md) |

This guide covers command-line options, manual language selection, direct source execution, project structure, and development commands.

## Running from source

To run from source, clone the repository and enter its root. Run the commands below from that directory.

```bash
git clone https://github.com/yaleksandr89/amnezia-opencck-cidr-converter.git
cd amnezia-opencck-cidr-converter
```

Windows: Windows PowerShell 5.1 (CLI also supports PowerShell 7). Linux/macOS: Bash, AWK and standard system utilities; URL mode needs `curl` or `wget`. `gum` 0.17.0 is bundled in ready-to-use packages; source TUI requires `gum` in PATH.

## Interactive TUI

Ready-to-use packages open the TUI automatically.

The TUI lets you select the source (URL or local JSON), output folder and language, repeat conversion and open the output folder.

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr-ui.ps1
```

Linux/macOS:

```bash
bash ./src/convert-opencck-cidr-ui.sh
```

Choose an output path different from the input JSON. Successful conversion replaces an existing output file. Review the route list before importing it.

## Interface language

The default mode is `auto`:

- Windows uses the current UI culture;
- macOS and Linux use `LC_ALL`, `LC_MESSAGES`, or `LANG`;
- English is used when a Russian locale is not detected.

Supported values:

```text
auto
ru
en
```

Windows:

```powershell
.\bin\convert-opencck-cidr.cmd -Language en
```

macOS and Linux:

```bash
./bin/convert-opencck-cidr.sh --language en
```

## Parameterized execution

The example URLs are abbreviated: replace `https://iplist.opencck.org/?...` with the full OpenCCK URL from your browser.

### Windows

```powershell
.\bin\convert-opencck-cidr.cmd `
  -SourceUrl "https://iplist.opencck.org/?..." `
  -OutputPath ".\routes.json" `
  -Language en
```

Local JSON:

```powershell
.\bin\convert-opencck-cidr.cmd `
  -InputPath ".\input.json" `
  -OutputPath ".\routes.json"
```

Options:

| Option | Purpose |
|---|---|
| `-SourceUrl` | OpenCCK URL |
| `-InputPath` | Local JSON in OpenCCK format |
| `-OutputPath` | Output JSON path |
| `-Language` | `auto`, `ru`, or `en` |
| `-PassThru` | `Success`, `RouteCount`, `OutputPath`, `ErrorMessage` (`src/convert-opencck-cidr.ps1`) |

### macOS and Linux

```bash
./bin/convert-opencck-cidr.sh \
  --source-url 'https://iplist.opencck.org/?...' \
  --output-path './routes.json' \
  --language en
```

Local JSON:

```bash
./bin/convert-opencck-cidr.sh \
  --input-path './input.json' \
  --output-path './routes.json'
```

Options:

| Option | Purpose |
|---|---|
| `--source-url`, `-u` | OpenCCK URL |
| `--input-path`, `-i` | Local JSON in OpenCCK format |
| `--output-path`, `-o` | Output JSON path |
| `--language`, `-l` | `auto`, `ru`, or `en` |
| `--machine-readable` | Machine-readable output for TUI and integrations |
| `--help`, `-h` | Show help |

When no output path is provided, the result is saved in the project root:

```text
amnezia-opencck-cidr.json
```

## Running the source files directly

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr.ps1 `
  -Language en
```

### macOS and Linux

```bash
bash ./src/convert-opencck-cidr.sh --language en
```

## Project structure

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

## Development

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### macOS and Linux

```bash
bash ./tests/run-tests.sh
```

GitHub Actions runs native tests on Windows, Ubuntu and macOS, builds standalone packages and stores them as CI artifacts.

Build in a separate checkout: build scripts replace their directories and archives in `dist/` and download `gum` with SHA-256 verification.

[gum license (MIT)](../../../../build/windows/third-party/GUM-LICENSE.txt).

[Contributing](../CONTRIBUTING.md) · [Security policy](../SECURITY.md) · [README](../README.md)
