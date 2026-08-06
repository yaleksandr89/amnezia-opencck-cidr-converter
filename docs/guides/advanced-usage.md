# Расширенное использование

## Выберите язык

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| **Выбран** | [English](./advanced-usage_en.md) | [Español](./advanced-usage_es.md) | [中文](./advanced-usage_zh.md) | [Français](./advanced-usage_fr.md) | [Deutsch](./advanced-usage_de.md) |

В этой инструкции собраны параметры запуска, ручной выбор языка, прямой запуск исходников, структура проекта и команды для разработки.

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

## Разработка

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### macOS и Linux

```bash
chmod +x ./tests/run-tests.sh
./tests/run-tests.sh
```

GitHub Actions запускает нативные тесты отдельно в Windows, Ubuntu и macOS.

Правила подготовки изменений находятся в [CONTRIBUTING.md](../../.github/CONTRIBUTING.md).
