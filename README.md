# Amnezia OpenCCK CIDR Converter

[![Source Code](https://img.shields.io/badge/source-yaleksandr89%2Famnezia--opencck--cidr--converter-blue.svg?style=flat-square)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter)
[![CI](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml/badge.svg)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml)
[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](LICENSE)

<p align="center">
  <img
    src="docs/assets/readme-cover.png"
    alt="Amnezia OpenCCK CIDR Converter — OpenCCK IPv4 CIDR to JSON converter for AmneziaVPN 5.x"
    width="100%"
  >
</p>

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

| Система | Готовый пакет | Архитектура |
|---|---|---|
| Windows 10/11 | `amnezia-opencck-cidr-converter_windows_x64.zip` | x64 |
| Linux | `amnezia-opencck-cidr-converter_linux_x64.tar.gz` | x64 |
| macOS | `amnezia-opencck-cidr-converter_macos_arm64.tar.gz` | Apple Silicon / arm64 |

Готовые пакеты публикуются в [GitHub Releases](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/releases).

В каждый standalone-пакет уже включён `gum`, поэтому отдельно устанавливать его не нужно.


## Быстрый старт

### 1. Скачайте готовый пакет

Откройте [GitHub Releases](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/releases) и скачайте архив для своей системы.

После распаковки запускайте:

- Windows: `amnezia-opencck-cidr-converter.exe`;
- Linux/macOS: `./amnezia-opencck-cidr-converter`.

Интерактивный интерфейс позволяет выбрать источник, папку результата и язык, а после конвертации — открыть папку с готовым JSON.

> [!NOTE]
> Windows-сборка не подписана коммерческим сертификатом, поэтому SmartScreen может показать предупреждение «Неизвестный издатель».

### 2. Подготовьте ссылку OpenCCK

1. Откройте [iplist.opencck.org](https://iplist.opencck.org/).
2. Выберите нужные сайты и сервисы.
3. Укажите формат **Amnezia**.
4. Укажите тип данных **IP-зоны IPv4 (CIDR)**.
5. Отключите пункт **«Сохранить как файл»**.
6. Скопируйте длинную ссылку из нижнего поля страницы.

### 3. Импортируйте результат

После завершения конвертации импортируйте созданный `amnezia-opencck-cidr.json` в приложение.

Запуск напрямую из исходников и CLI-режим по-прежнему поддерживаются.

Параметры запуска, выбор языка, прямой запуск исходников, структура проекта и тесты описаны в [расширенной инструкции](docs/guides/advanced-usage.md).

## Ограничения

- Поддерживается только IPv4 CIDR (`data=cidr4`).
- Для сетевой загрузки принимается только HTTPS-ссылка с домена `iplist.opencck.org`.
- Работа сетевого режима зависит от доступности и формата ответа OpenCCK.
- После исправления импорта в официальном клиенте необходимость в конвертере может исчезнуть.

## Обратная связь

- воспроизводимые ошибки — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues);
- вопросы и идеи — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

---

<p align="center">
  Если инструмент помог решить задачу, поставьте звезду на GitHub — так проект будет проще найти другим разработчикам. 🤘
</p>
