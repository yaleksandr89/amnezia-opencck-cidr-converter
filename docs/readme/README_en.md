# Amnezia OpenCCK CIDR Converter

[![CI](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml/badge.svg)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-brightgreen.svg)](../../LICENSE)

<p align="center">
  <img
    src="../assets/readme-cover.png"
    alt="Amnezia OpenCCK CIDR Converter — OpenCCK IPv4 CIDR to JSON converter for AmneziaVPN 5.x"
    width="100%"
  >
</p>

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

During a problematic import, the subnet prefix may be lost. The converter creates an entry where the CIDR is stored in `ip`:

```json
{
  "hostname": "route-000001.invalid",
  "ip": "142.250.0.0/15"
}
```

## What the converter does

- accepts a URL generated at `iplist.opencck.org`;
- validates and converts valid IPv4 CIDR entries;
- removes duplicates while preserving the original order;
- creates `amnezia-opencck-cidr.json` in the project root, ready for import.

## Supported systems

| System | Ready-to-use package | Architecture |
|---|---|---|
| Windows 10/11 | `amnezia-opencck-cidr-converter_windows_x64.zip` | x64 |
| Linux | `amnezia-opencck-cidr-converter_linux_x64.tar.gz` | x64 |
| macOS | `amnezia-opencck-cidr-converter_macos_arm64.tar.gz` | Apple Silicon / arm64 |

Ready-to-use packages are published in [GitHub Releases](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/releases).

Each standalone package already includes `gum`, so users do not need to install it separately.


## Quick start

### 1. Download a ready-to-use package

Open [GitHub Releases](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/releases) and download the archive for your system.

After extracting it, run:

- Windows: `amnezia-opencck-cidr-converter.exe`;
- Linux/macOS: `./amnezia-opencck-cidr-converter`.

The interactive interface lets you select the source, output directory, and language, then open the directory containing the generated JSON.

> [!NOTE]
> The Windows build is not signed with a commercial code-signing certificate, so SmartScreen may display an “Unknown publisher” warning.

### 2. Prepare the OpenCCK URL

1. Open [iplist.opencck.org](https://iplist.opencck.org/).
2. Select the required sites and services.
3. Choose the **Amnezia** format.
4. Choose **IPv4 CIDR ranges**.
5. Disable **Save as file**.
6. Copy the long URL from the field at the bottom of the page.

### 3. Import the result

After conversion, import the generated `amnezia-opencck-cidr.json` into the application.

Direct source execution and CLI mode remain supported.

Parameters, language selection, direct source execution, project structure, and tests are described in the [advanced usage guide](../guides/advanced-usage_en.md).

## Limitations

- Only IPv4 CIDR (`data=cidr4`) is supported.
- Network downloads accept only HTTPS URLs from `iplist.opencck.org`.
- Network mode depends on OpenCCK availability and response format.
- The converter may no longer be needed after the import issue is fixed in the official client.

## Feedback

- reproducible bugs — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues);
- questions and ideas — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

---

<p align="center">
  If this tool helped, consider starring the repository so other developers can find it. 🤘
</p>
