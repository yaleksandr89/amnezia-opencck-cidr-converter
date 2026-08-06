# Amnezia OpenCCK CIDR Converter

[![CI](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml/badge.svg)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-brightgreen.svg)](../../LICENSE)

## 选择语言

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../README.md) | [English](./README_en.md) | [Español](./README_es.md) | **已选择** | [Français](./README_fr.md) | [Deutsch](./README_de.md) |

将 OpenCCK 的 IPv4 CIDR 列表转换为可正确导入 AmneziaVPN 5.x 的 JSON。

本项目不会修改或修补客户端，只会在导入前转换列表格式。

> [!IMPORTANT]
> 这是针对 CIDR 导入问题的临时解决方案，并非 AmneziaVPN 官方格式。本项目与 AmneziaVPN 或 OpenCCK 团队均无关联。

## 问题说明

OpenCCK 可能会在 `hostname` 字段中返回 CIDR 值：

```json
{
  "hostname": "142.250.0.0/15",
  "ip": ""
}
```

在出现问题的导入过程中，子网前缀可能会丢失。转换器会将 CIDR 值移动到 `ip` 字段，并创建唯一的服务名称：

```json
{
  "hostname": "route-000001.invalid",
  "ip": "142.250.0.0/15"
}
```

实际路由保存在 `ip` 中。`.invalid` 域名仅用作记录的唯一键。

## 转换器的功能

1. 接收由 `iplist.opencck.org` 生成的 URL。
2. 验证 HTTPS、域名、`Amnezia` 格式和 `IPv4 CIDR` 数据类型。
3. 下载最新的 JSON 列表。
4. 验证 IPv4 CIDR 条目。
5. 在保留原始顺序的同时删除重复项。
6. 将 CIDR 从 `hostname` 移动到 `ip`。
7. 生成类似 `route-000001.invalid` 的连续名称。
8. 以无 BOM 的 UTF-8 JSON 格式写入结果。

为了便于开发和自动化测试，两种实现也支持转换本地 JSON 文件。

## 项目结构

```text
bin/                   面向用户的启动脚本
src/                   Windows 和 Unix 系统的原生实现
tests/                 测试和测试数据
docs/readme/           README 翻译
docs/contributing/     贡献指南翻译
docs/security/         安全策略翻译
.github/               CI、模板和 GitHub 社区文件
```

## 支持的系统

| 系统 | 启动方式 | 要求 |
|---|---|---|
| Windows 10/11 | `bin/convert-opencck-cidr.cmd` | Windows PowerShell 5.1 或 PowerShell 7 |
| macOS | `bin/convert-opencck-cidr.sh` | Bash，以及 `curl` 或 `wget` |
| Linux | `bin/convert-opencck-cidr.sh` | Bash，以及 `curl` 或 `wget` |

macOS 和 Linux 无需额外安装 Python 或 PowerShell。Windows 使用 PowerShell，macOS 和 Linux 使用原生 Bash 实现。

## 界面语言

转换器支持俄语和英语界面。

默认值为 `auto`：

- Windows 使用当前 UI 区域设置；
- macOS 和 Linux 使用 `LC_ALL`、`LC_MESSAGES` 或 `LANG`；
- 未检测到俄语区域设置时使用英语。

也可以显式指定语言。

Windows：

```powershell
.\bin\convert-opencck-cidr.cmd `
  -Language en
```

macOS 和 Linux：

```bash
./bin/convert-opencck-cidr.sh --language en
```

可用值：`auto`、`ru`、`en`。

## 快速开始

### 1. 准备 OpenCCK URL

1. 打开 [iplist.opencck.org](https://iplist.opencck.org/)。
2. 选择所需的网站和服务。
3. 选择 **Amnezia** 格式。
4. 选择 **IPv4 CIDR 网段** 数据类型。
5. 关闭 **保存为文件**。
6. 复制页面底部字段中的长 URL。

### 2. 运行转换器

#### Windows

双击：

```text
bin/convert-opencck-cidr.cmd
```

也可以在终端中传递参数：

```powershell
.\bin\convert-opencck-cidr.cmd `
  -SourceUrl "https://iplist.opencck.org/?..." `
  -OutputPath ".\routes.json" `
  -Language en
```

#### macOS 和 Linux

首次使用时授予执行权限：

```bash
chmod +x ./bin/convert-opencck-cidr.sh
```

交互模式：

```bash
./bin/convert-opencck-cidr.sh
```

或者直接传递参数：

```bash
./bin/convert-opencck-cidr.sh \
  --source-url 'https://iplist.opencck.org/?...' \
  --output-path './routes.json' \
  --language en
```

未指定输出路径时，会在项目根目录创建以下文件：

```text
amnezia-opencck-cidr.json
```

将生成的 JSON 导入应用程序。

## 直接运行实现

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr.ps1 `
  -Language en
```

参数：`-SourceUrl`、`-InputPath`、`-OutputPath`、`-Language`。

### macOS 和 Linux

```bash
bash ./src/convert-opencck-cidr.sh --language en
```

参数：`--source-url`、`--input-path`、`--output-path`、`--language`。

## 限制

- 仅支持 IPv4 CIDR（`data=cidr4`）。
- 网络下载只接受来自 `iplist.opencck.org` 域名的 HTTPS URL。
- 网络模式依赖 OpenCCK 的可用性和响应格式。
- **官方客户端修复导入问题后，可能不再需要此转换器。**

## 开发

### Windows 测试

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### macOS 和 Linux 测试

```bash
chmod +x ./tests/run-tests.sh
./tests/run-tests.sh
```

GitHub Actions 会分别在 Windows、Ubuntu 和 macOS 上运行原生测试。

贡献规则请参阅 [CONTRIBUTING.md](../contributing/CONTRIBUTING_zh.md)。

## 反馈

- 可复现的错误 — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues)；
- 问题和建议 — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions)。

---

<p align="center">
  如果这个工具对您有帮助，请为仓库加星，让其他开发者更容易找到它。🤘
</p>
