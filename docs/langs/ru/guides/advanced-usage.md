# Расширенное использование

## Выберите язык

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| **Выбран** | [English](../../en/guides/advanced-usage.md) | [Español](../../es/guides/advanced-usage.md) | [中文](../../zh/guides/advanced-usage.md) | [Français](../../fr/guides/advanced-usage.md) | [Deutsch](../../de/guides/advanced-usage.md) |

В этой инструкции собраны параметры запуска, интерактивный TUI, ручной выбор языка, прямой запуск исходников, структура проекта и команды для разработки.

## Запуск из исходников

Для запуска из исходников клонируйте репозиторий и перейдите в его корень. Команды ниже выполняются из этого каталога.

```bash
git clone https://github.com/yaleksandr89/amnezia-opencck-cidr-converter.git
cd amnezia-opencck-cidr-converter
```

Windows: Windows PowerShell 5.1 (CLI также поддерживает PowerShell 7). Linux/macOS: Bash, AWK и стандартные системные утилиты; для URL нужен `curl` или `wget`. `gum` 0.17.0 включён в готовые пакеты; для TUI из исходников нужен `gum` в PATH.

## Интерактивный TUI

Готовые пакеты автоматически открывают TUI.

TUI позволяет выбрать источник (ссылку или локальный JSON), папку результата и язык, повторить конвертацию и открыть папку с JSON.

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr-ui.ps1
```

Linux/macOS:

```bash
bash ./src/convert-opencck-cidr-ui.sh
```

Указывайте для результата отдельный путь, не совпадающий с исходным JSON. При выборе существующего результата успешная конвертация заменяет его. Перед импортом проверьте список маршрутов.

## Язык интерфейса

По умолчанию используется режим `auto`:

- Windows определяет язык по текущей UI-культуре;
- macOS и Linux используют `LC_ALL`, `LC_MESSAGES` или `LANG`;
- если русская локаль не обнаружена, используется английский.

Поддерживаемые значения:

```text
auto
ru
en
```

Windows:

```powershell
.\bin\convert-opencck-cidr.cmd -Language en
```

macOS и Linux:

```bash
./bin/convert-opencck-cidr.sh --language en
```

## Параметризованный запуск

Ссылки в примерах сокращены: вместо `https://iplist.opencck.org/?...` подставьте полную ссылку OpenCCK из браузера.

### Windows

```powershell
.\bin\convert-opencck-cidr.cmd `
  -SourceUrl "https://iplist.opencck.org/?..." `
  -OutputPath ".\routes.json" `
  -Language ru
```

Локальный JSON:

```powershell
.\bin\convert-opencck-cidr.cmd `
  -InputPath ".\input.json" `
  -OutputPath ".\routes.json"
```

Параметры:

| Параметр | Назначение |
|---|---|
| `-SourceUrl` | Ссылка OpenCCK |
| `-InputPath` | Локальный JSON в формате OpenCCK |
| `-OutputPath` | Путь к результирующему JSON |
| `-Language` | `auto`, `ru` или `en` |
| `-PassThru` | `Success`, `RouteCount`, `OutputPath`, `ErrorMessage` (`src/convert-opencck-cidr.ps1`) |

### macOS и Linux

```bash
./bin/convert-opencck-cidr.sh \
  --source-url 'https://iplist.opencck.org/?...' \
  --output-path './routes.json' \
  --language ru
```

Локальный JSON:

```bash
./bin/convert-opencck-cidr.sh \
  --input-path './input.json' \
  --output-path './routes.json'
```

Параметры:

| Параметр | Назначение |
|---|---|
| `--source-url`, `-u` | Ссылка OpenCCK |
| `--input-path`, `-i` | Локальный JSON в формате OpenCCK |
| `--output-path`, `-o` | Путь к результирующему JSON |
| `--language`, `-l` | `auto`, `ru` или `en` |
| `--machine-readable` | Машинный вывод для TUI и интеграций |
| `--help`, `-h` | Справка |

Если `OutputPath` не указан, результат сохраняется в корне проекта:

```text
amnezia-opencck-cidr.json
```

## Прямой запуск исходников

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr.ps1 `
  -Language ru
```

### macOS и Linux

```bash
bash ./src/convert-opencck-cidr.sh --language ru
```

## Структура проекта

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

## Разработка

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### macOS и Linux

```bash
bash ./tests/run-tests.sh
```

GitHub Actions запускает нативные тесты на Windows, Ubuntu и macOS, собирает standalone-пакеты и сохраняет их в артефактах CI.

Сборка выполняется в отдельном checkout: скрипты заменяют свои каталоги и архивы в `dist/` и скачивают `gum` с проверкой SHA-256.

[Лицензия gum (MIT)](../../../../build/windows/third-party/GUM-LICENSE.txt).

[Участие в разработке](../../../../.github/CONTRIBUTING.md) · [Политика безопасности](../../../../.github/SECURITY.md) · [README](../../../../README.md)
