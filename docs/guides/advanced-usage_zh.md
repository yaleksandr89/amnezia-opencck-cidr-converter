# 高级使用

## 选择语言

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](./advanced-usage.md) | [English](./advanced-usage_en.md) | [Español](./advanced-usage_es.md) | **已选择** | [Français](./advanced-usage_fr.md) | [Deutsch](./advanced-usage_de.md) |

本指南包含命令行参数、手动语言选择、直接运行源码、项目结构和开发命令。

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
├── bin/                     # точки запуска
│   ├── convert-opencck-cidr.cmd    # Windows
│   └── convert-opencck-cidr.sh     # macOS и Linux
├── src/                     # основная логика конвертера
│   ├── convert-opencck-cidr.ps1    # реализация для Windows
│   └── convert-opencck-cidr.sh     # реализация для macOS и Linux
├── tests/                   # автоматические тесты и тестовые данные
├── docs/
│   ├── readme/              # переводы README
│   ├── guides/              # расширенные инструкции
│   ├── contributing/        # переводы правил участия
│   └── security/            # переводы политики безопасности
├── .github/                 # CI, шаблоны Issues и Pull Request
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
chmod +x ./tests/run-tests.sh
./tests/run-tests.sh
```

GitHub Actions 会分别在 Windows、Ubuntu 和 macOS 上运行原生测试。

贡献规则请参阅 [CONTRIBUTING.md](../contributing/CONTRIBUTING_zh.md)。
