## What changed / Что изменено

Describe the change and its purpose.  
Кратко опишите изменение и его цель.

## How to verify / Как проверить

List the commands or verification steps.  
Опишите команды или шаги проверки.

## Affected platforms / Затронутые платформы

- [ ] Windows
- [ ] macOS
- [ ] Linux

## Checklist / Чек-лист

- [ ] No sensitive data is included. / Изменение не добавляет чувствительные данные.
- [ ] Windows tests pass: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\run-tests.ps1`.
- [ ] Unix tests pass: `./tests/run-tests.sh`.
- [ ] Both implementations are synchronized or the difference is justified. / Обе реализации синхронизированы либо различие явно обосновано.
- [ ] Russian and English messages are synchronized. / Русские и английские сообщения синхронизированы.
- [ ] Documentation is updated when behavior changes. / Документация обновлена, если поведение изменилось.
