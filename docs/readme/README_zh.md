# Amnezia OpenCCK CIDR Converter

[![Source Code](https://img.shields.io/badge/source-yaleksandr89%2Famnezia--opencck--cidr--converter-blue.svg?style=flat-square)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter)
[![CI](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml/badge.svg)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml)
[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](../../LICENSE)

<p align="center">
  <img
    src="../assets/readme-cover.png"
    alt="Amnezia OpenCCK CIDR Converter — OpenCCK IPv4 CIDR to JSON converter for AmneziaVPN 5.x"
    width="100%"
  >
</p>

## 选择语言

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../README.md) | [English](./README_en.md) | [Español](./README_es.md) | **已选择** | [Français](./README_fr.md) | [Deutsch](./README_de.md) |

将 OpenCCK 的 IPv4 CIDR 列表转换为可正确导入 AmneziaVPN 5.x 的 JSON。

本项目不会修改或修补客户端，只会在导入前转换列表格式。

> [!IMPORTANT]
> 这是针对 CIDR 导入问题的临时解决方案，并非 AmneziaVPN 官方格式。本项目与 AmneziaVPN 或 OpenCCK 团队均无关联。

## 问题说明

OpenCCK 可能会在 `hostname` 字段中返回 CIDR：

```json
{
  "hostname": "142.250.0.0/15",
  "ip": ""
}
```

出现导入问题时，子网前缀可能会丢失。转换器会生成一条将 CIDR 保存在 `ip` 字段中的记录：

```json
{
  "hostname": "route-000001.invalid",
  "ip": "142.250.0.0/15"
}
```

## 转换器的功能

- 接收由 `iplist.opencck.org` 生成的 URL；
- 校验并转换有效的 IPv4 CIDR 记录；
- 去除重复项并保留原始顺序；
- 在项目根目录创建可直接导入的 `amnezia-opencck-cidr.json`。

## 支持的系统

| 系统 | 启动方式 | 要求 |
|---|---|---|
| Windows 10/11 | `bin/convert-opencck-cidr.cmd` | Windows PowerShell 5.1 或 PowerShell 7 |
| macOS | `bin/convert-opencck-cidr.sh` | Bash，以及 `curl` 或 `wget` |
| Linux | `bin/convert-opencck-cidr.sh` | Bash，以及 `curl` 或 `wget` |

## 快速开始

### 1. 准备 OpenCCK URL

1. 打开 [iplist.opencck.org](https://iplist.opencck.org/)。
2. 选择所需的网站和服务。
3. 选择 **Amnezia** 格式。
4. 选择 **IPv4 CIDR 网段**。
5. 关闭 **保存为文件**。
6. 复制页面底部字段中的长 URL。

### 2. 运行转换器

#### Windows

双击：

```text
bin/convert-opencck-cidr.cmd
```

#### macOS 和 Linux

首次运行前授予执行权限：

```bash
chmod +x ./bin/convert-opencck-cidr.sh
```

运行：

```bash
./bin/convert-opencck-cidr.sh
```

界面语言会自动检测，也可以在参数化运行时手动指定。

完成后，将生成的 JSON 导入应用程序。

参数、语言选择、直接运行源码、项目结构和测试说明位于[高级使用指南](../guides/advanced-usage_zh.md)。

## 限制

- 仅支持 IPv4 CIDR（`data=cidr4`）。
- 网络下载仅接受 `iplist.opencck.org` 的 HTTPS URL。
- 网络模式依赖 OpenCCK 的可用性和响应格式。
- 官方客户端修复导入问题后，可能不再需要本转换器。

## 反馈

- 可复现的错误 — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues)；
- 问题和建议 — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions)。

---

<p align="center">
  如果这个工具帮到了您，请为仓库点亮 Star，方便其他开发者找到它。🤘
</p>
