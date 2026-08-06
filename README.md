# Amnezia OpenCCK CIDR Converter

[![CI](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml/badge.svg)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)

Конвертер IPv4 CIDR-списков OpenCCK в JSON для корректного импорта в AmneziaVPN 5.x.

Проект не изменяет клиент и не является его патчем. Он преобразует список перед импортом.

> [!IMPORTANT]
> Это временное решение технической проблемы импорта CIDR, а не официальный формат AmneziaVPN. Проект не связан с командами AmneziaVPN и OpenCCK.

## Решаемая проблема

OpenCCK может вернуть CIDR в поле `hostname`:

```json
{
  "hostname": "142.250.0.0/15",
  "ip": ""
}
```

При проблемном импорте маска подсети может потеряться. Конвертер переносит CIDR в поле `ip` и создаёт уникальное служебное имя:

```json
{
  "hostname": "route-000001.invalid",
  "ip": "142.250.0.0/15"
}
```

Реальный маршрут хранится в `ip`. Имя под доменом `.invalid` используется только как уникальный ключ записи.

## Что делает конвертер

1. Принимает ссылку, сформированную на `iplist.opencck.org`.
2. Проверяет HTTPS, домен, формат `Amnezia` и тип данных `IPv4 CIDR`.
3. Скачивает актуальный JSON.
4. Проверяет IPv4 CIDR-записи.
5. Удаляет дубли, сохраняя исходный порядок.
6. Переносит CIDR из `hostname` в `ip`.
7. Создаёт последовательные имена `route-000001.invalid`.
8. Записывает результат в UTF-8 JSON без BOM.

Для разработки и автоматической проверки обе реализации также поддерживают преобразование локального JSON.

## Структура проекта

```text
bin/        пользовательские точки запуска
src/        нативные реализации для Windows и Unix-систем
tests/      тесты и тестовые данные
.github/    CI, шаблоны и служебные файлы GitHub
```

Каталог `docs/` будет добавлен вместе с мультиязычной документацией.

## Поддерживаемые системы

| Система | Запуск | Системные требования |
|---|---|---|
| Windows 10/11 | `bin/convert-opencck-cidr.cmd` | Windows PowerShell 5.1 или PowerShell 7 |
| macOS | `bin/convert-opencck-cidr.sh` | Bash и `curl` либо `wget` |
| Linux | `bin/convert-opencck-cidr.sh` | Bash и `curl` либо `wget` |

Дополнительно устанавливать Python или PowerShell в macOS/Linux не требуется. Windows использует PowerShell, а macOS и Linux — нативный Bash-сценарий.

## Быстрый старт

### 1. Подготовьте ссылку OpenCCK

1. Откройте [iplist.opencck.org](https://iplist.opencck.org/).
2. Выберите нужные сайты и сервисы.
3. Укажите формат **Amnezia**.
4. Укажите тип данных **IP-зоны IPv4 (CIDR)**.
5. Отключите пункт **«Сохранить как файл»**.
6. Скопируйте длинную ссылку из нижнего поля страницы.

### 2. Запустите конвертер

#### Windows

Дважды щёлкните:

```text
bin/convert-opencck-cidr.cmd
```

Или передайте параметры из терминала:

```powershell
.\bin\convert-opencck-cidr.cmd `
  -SourceUrl "https://iplist.opencck.org/?..." `
  -OutputPath ".\routes.json"
```

#### macOS и Linux

Разрешите запуск один раз:

```bash
chmod +x ./bin/convert-opencck-cidr.sh
```

Интерактивный запуск:

```bash
./bin/convert-opencck-cidr.sh
```

Или передайте параметры:

```bash
./bin/convert-opencck-cidr.sh \
  --source-url 'https://iplist.opencck.org/?...' \
  --output-path './routes.json'
```

Если путь не указан, в корне проекта создаётся файл:

```text
amnezia-opencck-cidr.json
```

После формирования импортируйте полученный JSON в приложение.

## Прямой запуск исходников

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr.ps1
```

Параметры: `-SourceUrl`, `-InputPath`, `-OutputPath`.

### macOS и Linux

```bash
bash ./src/convert-opencck-cidr.sh
```

Параметры: `--source-url`, `--input-path`, `--output-path`.

## Ограничения

- Поддерживается только IPv4 CIDR (`data=cidr4`).
- Для сетевой загрузки принимается только HTTPS-ссылка с домена `iplist.opencck.org`.
- Работа сетевого режима зависит от доступности и формата ответа OpenCCK.
- **После исправления импорта в официальном клиенте необходимость в конвертере может исчезнуть.**

## Разработка

### Тесты в Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### Тесты в macOS и Linux

```bash
chmod +x ./tests/run-tests.sh
./tests/run-tests.sh
```

GitHub Actions выполняет нативные тесты отдельно в Windows, Ubuntu и macOS.

Правила подготовки изменений находятся в [CONTRIBUTING.md](.github/CONTRIBUTING.md).

## Обратная связь

- воспроизводимые ошибки — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues);
- вопросы и идеи — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

---

<p align="center">
  Если инструмент помог решить задачу, поставьте звезду на GitHub — так проект будет проще найти другим разработчикам. 🤘
</p>
