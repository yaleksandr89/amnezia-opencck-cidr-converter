# Участие в разработке

## Выберите язык

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| **Выбран** | [English](../docs/contributing/CONTRIBUTING_en.md) | [Español](../docs/contributing/CONTRIBUTING_es.md) | [中文](../docs/contributing/CONTRIBUTING_zh.md) | [Français](../docs/contributing/CONTRIBUTING_fr.md) | [Deutsch](../docs/contributing/CONTRIBUTING_de.md) |

Спасибо за интерес к проекту.

## Перед началом

- Для воспроизводимой ошибки создайте Issue.
- Для вопроса по использованию откройте Discussion в категории Q&A.
- Для крупного изменения сначала обсудите идею.

## Реализации

Проект содержит две нативные реализации одного поведения:

- `src/convert-opencck-cidr.ps1` — Windows;
- `src/convert-opencck-cidr.sh` — macOS и Linux.

Изменение логики конвертации должно быть внесено в обе реализации либо явно обосновано как платформенное.

Пользовательские сообщения поддерживают русский и английский языки. При добавлении или изменении сообщения обновите обе локализации.

## Ветки

```text
feature/add-cidr6-support
fix/windows-path-handling
docs/update-linux-guide
```

## Коммиты

Рекомендуемый формат — Conventional Commits:

```text
feat: add local JSON input
fix: preserve CIDR prefix during conversion
docs: clarify platform requirements
test: cover duplicate CIDR entries
chore: update GitHub workflow
```

## Локальная проверка

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

macOS и Linux:

```bash
./tests/run-tests.sh
```

## Pull Request

В Pull Request опишите:

- какую проблему решает изменение;
- как проверить результат;
- какие платформы затронуты;
- синхронизированы ли обе реализации;
- синхронизированы ли русские и английские сообщения;
- требуется ли обновление документации.

Не добавляйте в репозиторий приватные конфигурации, ключи, токены, адреса личных серверов и сгенерированные списки маршрутов.
