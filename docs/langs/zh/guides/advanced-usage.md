# 高级使用

## 选择语言

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../ru/guides/advanced-usage.md) | [English](../../en/guides/advanced-usage.md) | [Español](../../es/guides/advanced-usage.md) | **已选择** | [Français](../../fr/guides/advanced-usage.md) | [Deutsch](../../de/guides/advanced-usage.md) |

本指南包含命令行参数、手动语言选择、直接运行源码、项目结构和开发命令。

## 从源码运行

克隆仓库并进入项目根目录。从该目录运行以下命令。

```bash
git clone https://github.com/yaleksandr89/amnezia-opencck-cidr-converter.git
cd amnezia-opencck-cidr-converter
```

Windows：Windows PowerShell 5.1（CLI 也支持 PowerShell 7）。Linux/macOS：Bash、AWK 和标准系统工具；URL 模式需要 `curl` 或 `wget`。软件包包含 `gum` 0.17.0；从源码运行 TUI 时需在 PATH 中提供 `gum`。

## 交互式 TUI

可直接使用的软件包会自动打开 TUI。

TUI 支持选择来源（URL 或本地 JSON）、输出目录和语言，重复转换并打开输出目录。

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr-ui.ps1
```

Linux/macOS:

```bash
bash ./src/convert-opencck-cidr-ui.sh
```

输出路径应与输入 JSON 不同。转换成功时会替换现有输出文件。导入前请检查路由列表。

## 界面语言

默认使用 `auto`：

- Windows 使用当前 UI 区域设置；
- macOS 和 Linux 使用 `LC_ALL`、`LC_MESSAGES` 或 `LANG`；
- 未检测到俄语区域设置时使用英语。

支持的值：

```text
auto
ru
en
```

Windows：

```powershell
.\bin\convert-opencck-cidr.cmd -Language en
```

macOS 和 Linux：

```bash
./bin/convert-opencck-cidr.sh --language en
```

## 参数化运行

示例 URL 为缩写：请将 `https://iplist.opencck.org/?...` 替换为浏览器中复制的完整 OpenCCK URL。

### Windows

```powershell
.\bin\convert-opencck-cidr.cmd `
  -SourceUrl "https://iplist.opencck.org/?..." `
  -OutputPath ".\routes.json" `
  -Language en
```

本地 JSON：

```powershell
.\bin\convert-opencck-cidr.cmd `
  -InputPath ".\input.json" `
  -OutputPath ".\routes.json"
```

参数：

| 参数 | 用途 |
|---|---|
| `-SourceUrl` | OpenCCK URL |
| `-InputPath` | OpenCCK 格式的本地 JSON |
| `-OutputPath` | 输出 JSON 路径 |
| `-Language` | `auto`、`ru` 或 `en` |
| `-PassThru` | `Success`, `RouteCount`, `OutputPath`, `ErrorMessage` (`src/convert-opencck-cidr.ps1`) |

### macOS 和 Linux

```bash
./bin/convert-opencck-cidr.sh \
  --source-url 'https://iplist.opencck.org/?...' \
  --output-path './routes.json' \
  --language en
```

本地 JSON：

```bash
./bin/convert-opencck-cidr.sh \
  --input-path './input.json' \
  --output-path './routes.json'
```

参数：

| 参数 | 用途 |
|---|---|
| `--source-url`, `-u` | OpenCCK URL |
| `--input-path`, `-i` | OpenCCK 格式的本地 JSON |
| `--output-path`, `-o` | 输出 JSON 路径 |
| `--language`, `-l` | `auto`、`ru` 或 `en` |
| `--machine-readable` | 用于 TUI 和集成的机器可读输出 |
| `--help`, `-h` | 显示帮助 |

未指定输出路径时，结果会保存到项目根目录：

```text
amnezia-opencck-cidr.json
```

## 直接运行源码

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr.ps1 `
  -Language en
```

### macOS 和 Linux

```bash
bash ./src/convert-opencck-cidr.sh --language en
```

## 项目结构

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

## 开发

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### macOS 和 Linux

```bash
bash ./tests/run-tests.sh
```

GitHub Actions 在 Windows、Ubuntu 和 macOS 上运行原生测试，构建 standalone 软件包并保存为 CI 产物。

请在独立工作副本中构建：脚本会替换 `dist/` 中对应的目录和压缩包，并下载 `gum` 进行 SHA-256 校验。

[gum 许可证（MIT）](../../../../build/windows/third-party/GUM-LICENSE.txt).

[参与开发](../CONTRIBUTING.md) · [安全政策](../SECURITY.md) · [README](../README.md)
