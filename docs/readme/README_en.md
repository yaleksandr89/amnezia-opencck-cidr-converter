# Amnezia OpenCCK CIDR Converter

[![CI](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml/badge.svg)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-brightgreen.svg)](../../LICENSE)

## Choose a language

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../README.md) | **Selected** | [Español](./README_es.md) | [中文](./README_zh.md) | [Français](./README_fr.md) | [Deutsch](./README_de.md) |

Converts OpenCCK IPv4 CIDR lists to JSON that can be imported correctly into AmneziaVPN 5.x.

The project does not modify or patch the client. It transforms the list before import.

> [!IMPORTANT]
> This is a temporary workaround for a CIDR import issue, not an official AmneziaVPN format. The project is not affiliated with the AmneziaVPN or OpenCCK teams.

## Problem

OpenCCK may return a CIDR value in the `hostname` field:

```json
{
  "hostname": "142.250.0.0/15",
  "ip": ""
}
```

During a problematic import, the subnet prefix may be lost. The converter moves the CIDR value to `ip` and creates a unique service name:

```json
{
  "hostname": "route-000001.invalid",
  "ip": "142.250.0.0/15"
}
```

The actual route is stored in `ip`. The `.invalid` hostname is used only as a unique record key.

## What the converter does

1. Accepts a URL generated at `iplist.opencck.org`.
2. Validates HTTPS, the domain, the `Amnezia` format, and the `IPv4 CIDR` data type.
3. Downloads the current JSON list.
4. Validates IPv4 CIDR entries.
5. Removes duplicates while preserving the original order.
6. Moves CIDR values from `hostname` to `ip`.
7. Generates sequential names such as `route-000001.invalid`.
8. Writes UTF-8 JSON without BOM.

Both implementations can also convert a local JSON file for development and automated testing.

## Project structure

```text
bin/                   user-facing launchers
src/                   native implementations for Windows and Unix systems
tests/                 tests and fixtures
docs/readme/           README translations
docs/contributing/     contribution guide translations
docs/security/         security policy translations
.github/               CI, templates, and GitHub community files
```

## Supported systems

| System | Launcher | Requirements |
|---|---|---|
| Windows 10/11 | `bin/convert-opencck-cidr.cmd` | Windows PowerShell 5.1 or PowerShell 7 |
| macOS | `bin/convert-opencck-cidr.sh` | Bash and either `curl` or `wget` |
| Linux | `bin/convert-opencck-cidr.sh` | Bash and either `curl` or `wget` |

Python or PowerShell does not need to be installed on macOS or Linux. Windows uses PowerShell, while macOS and Linux use the native Bash implementation.

## Interface language

The converter supports Russian and English.

The default value is `auto`:

- Windows uses the current UI culture;
- macOS and Linux use `LC_ALL`, `LC_MESSAGES`, or `LANG`;
- English is used when a Russian locale is not detected.

You can select a language explicitly.

Windows:

```powershell
.\bin\convert-opencck-cidr.cmd `
  -Language en
```

macOS and Linux:

```bash
./bin/convert-opencck-cidr.sh --language en
```

Accepted values: `auto`, `ru`, `en`.

## Quick start

### 1. Prepare an OpenCCK URL

1. Open [iplist.opencck.org](https://iplist.opencck.org/).
2. Select the required sites and services.
3. Select the **Amnezia** format.
4. Select **IPv4 CIDR ranges** as the data type.
5. Disable **Save as file**.
6. Copy the long URL from the field at the bottom of the page.

### 2. Run the converter

#### Windows

Double-click:

```text
bin/convert-opencck-cidr.cmd
```

Or pass options from a terminal:

```powershell
.\bin\convert-opencck-cidr.cmd `
  -SourceUrl "https://iplist.opencck.org/?..." `
  -OutputPath ".\routes.json" `
  -Language en
```

#### macOS and Linux

Allow execution once:

```bash
chmod +x ./bin/convert-opencck-cidr.sh
```

Interactive mode:

```bash
./bin/convert-opencck-cidr.sh
```

Or pass options directly:

```bash
./bin/convert-opencck-cidr.sh \
  --source-url 'https://iplist.opencck.org/?...' \
  --output-path './routes.json' \
  --language en
```

When no output path is provided, the following file is created in the project root:

```text
amnezia-opencck-cidr.json
```

Import the generated JSON into the application.

## Running the implementations directly

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr.ps1 `
  -Language en
```

Options: `-SourceUrl`, `-InputPath`, `-OutputPath`, `-Language`.

### macOS and Linux

```bash
bash ./src/convert-opencck-cidr.sh --language en
```

Options: `--source-url`, `--input-path`, `--output-path`, `--language`.

## Limitations

- Only IPv4 CIDR (`data=cidr4`) is supported.
- Network downloads accept only HTTPS URLs from `iplist.opencck.org`.
- Network mode depends on OpenCCK availability and response format.
- **The converter may no longer be needed after the import issue is fixed in the official client.**

## Development

### Windows tests

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### macOS and Linux tests

```bash
chmod +x ./tests/run-tests.sh
./tests/run-tests.sh
```

GitHub Actions runs native tests separately on Windows, Ubuntu, and macOS.

Contribution guidelines are available in [CONTRIBUTING.md](../contributing/CONTRIBUTING_en.md).

## Feedback

- reproducible bugs — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues);
- questions and ideas — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

---

<p align="center">
  If this tool helped, consider starring the repository so other developers can find it. 🤘
</p>
