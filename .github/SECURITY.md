# Безопасность

## Выберите язык

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| **Выбран** | [English](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/blob/master/docs/langs/en/SECURITY.md) | [Español](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/blob/master/docs/langs/es/SECURITY.md) | [中文](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/blob/master/docs/langs/zh/SECURITY.md) | [Français](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/blob/master/docs/langs/fr/SECURITY.md) | [Deutsch](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/blob/master/docs/langs/de/SECURITY.md) |

Политика распространяется на текущий стабильный релиз и актуальный master. Более ранние версии отдельно не сопровождаются.

Проект небольшой и поддерживается одним автором. Если вы нашли проблему безопасности, сообщите о ней так, чтобы детали не оказались в открытом доступе раньше исправления.

## Что лучше сообщать приватно

- выполнение произвольной команды через ссылку, путь или аргументы;
- обход проверки HTTPS или домена `iplist.opencck.org`;
- запись результата не в тот путь, который указал пользователь;
- появление в результате маршрутов, которых не было во входных данных;
- подмена или небезопасная публикация релизного архива.

Обычные ошибки конвертации, вопросы по запуску и предложения функций можно публиковать в [Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues) или [Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

## Как сообщить

Предпочтительный вариант — GitHub Private Vulnerability Reporting:

1. Откройте **Security and quality**.
2. Перейдите в **Advisories**.
3. Нажмите **Report a vulnerability**.
4. Опишите проблему без публикации её в открытом Issue.

Если приватная форма недоступна, создайте короткий Issue без exploit-кода и чувствительных деталей и попросите приватный канал связи.

## Что приложить

По возможности укажите:

- версию релиза или commit SHA;
- операционную систему и среду запуска;
- краткое описание влияния;
- минимальные шаги воспроизведения;
- обезличенный пример входных данных.

Не публикуйте ключи, токены, приватные конфигурации и адреса личных серверов.

## Что будет дальше

Я постараюсь подтвердить получение отчёта, воспроизвести проблему и подготовить исправление. Фиксированного SLA и программы вознаграждений у проекта нет. Публикацию технических деталей лучше согласовать после выхода исправления.

[Расширенное использование: CLI, TUI, исходники и тесты](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/blob/master/docs/langs/ru/guides/advanced-usage.md) · [GitHub Security](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/security)
