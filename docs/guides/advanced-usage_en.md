# Advanced usage

## Choose a language

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](./advanced-usage.md) | **Selected** | [Español](./advanced-usage_es.md) | [中文](./advanced-usage_zh.md) | [Français](./advanced-usage_fr.md) | [Deutsch](./advanced-usage_de.md) |

This guide covers command-line options, manual language selection, direct source execution, project structure, and development commands.

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

## Development

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### macOS and Linux

```bash
chmod +x ./tests/run-tests.sh
./tests/run-tests.sh
```

GitHub Actions runs native tests separately on Windows, Ubuntu, and macOS.

Contribution rules are available in [CONTRIBUTING.md](../contributing/CONTRIBUTING_en.md).
