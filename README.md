# Amnezia OpenCCK CIDR Converter

[![CI](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml/badge.svg)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)

## Выберите язык

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| **Выбран** | [English](docs/readme/README_en.md) | [Español](docs/readme/README_es.md) | [中文](docs/readme/README_zh.md) | [Français](docs/readme/README_fr.md) | [Deutsch](docs/readme/README_de.md) |

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

При проблемном импорте маска подсети может потеряться. Конвертер формирует запись, в которой CIDR хранится в поле `ip`:

```json
{
  "hostname": "route-000001.invalid",
  "ip": "142.250.0.0/15"
}
```

## Что делает конвертер

- принимает ссылку, сформированную на `iplist.opencck.org`;
- проверяет и преобразует корректные IPv4 CIDR-записи;
- удаляет дубли, сохраняя исходный порядок;
- создаёт в корне проекта файл `amnezia-opencck-cidr.json`, готовый для импорта.

## Поддерживаемые системы

| Система | Запуск | Требования |
|---|---|---|
| Windows 10/11 | `bin/convert-opencck-cidr.cmd` | Windows PowerShell 5.1 или PowerShell 7 |
| macOS | `bin/convert-opencck-cidr.sh` | Bash и `curl` либо `wget` |
| Linux | `bin/convert-opencck-cidr.sh` | Bash и `curl` либо `wget` |

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

#### macOS и Linux

Разрешите запуск один раз:

```bash
chmod +x ./bin/convert-opencck-cidr.sh
```

Запустите:

```bash
./bin/convert-opencck-cidr.sh
```

Язык интерфейса определяется автоматически. Его можно указать вручную при параметризованном запуске.

После завершения импортируйте созданный JSON в приложение.

Параметры запуска, выбор языка, прямой запуск исходников, структура проекта и тесты описаны в [расширенной инструкции](docs/guides/advanced-usage.md).

## Ограничения

- Поддерживается только IPv4 CIDR (`data=cidr4`).
- Для сетевой загрузки принимается только HTTPS-ссылка с домена `iplist.opencck.org`.
- Работа сетевого режима зависит от доступности и формата ответа OpenCCK.
- После исправления импорта в официальном клиенте необходимость в конвертере может исчезнуть.

## Документация

- [Расширенное использование](docs/guides/advanced-usage.md)
- [Участие в разработке](.github/CONTRIBUTING.md)
- [Безопасность](.github/SECURITY.md)

## Обратная связь

- воспроизводимые ошибки — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues);
- вопросы и идеи — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

---

<p align="center">
  Если инструмент помог решить задачу, поставьте звезду на GitHub — так проект будет проще найти другим разработчикам. 🤘
</p>
