# Contributing

## Choose a language

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../../.github/CONTRIBUTING.md) | **Selected** | [Español](../es/CONTRIBUTING.md) | [中文](../zh/CONTRIBUTING.md) | [Français](../fr/CONTRIBUTING.md) | [Deutsch](../de/CONTRIBUTING.md) |

Thank you for your interest in the project.

## Before you start

- Open an Issue for a reproducible bug.
- Use the Q&A Discussion category for usage questions.
- Discuss large changes before implementing them.

## Implementations

The project contains two native implementations of the same behavior:

- `src/convert-opencck-cidr.ps1` — Windows;
- `src/convert-opencck-cidr.sh` — macOS and Linux.

Conversion logic changes must be applied to both implementations unless a platform-specific difference is explicitly justified.

User-facing messages support Russian and English. Update both localizations when adding or changing a message.

Keep all six documentation locales in sync.

## Branches

```text
feature/add-cidr6-support
fix/windows-path-handling
docs/update-linux-guide
```

## Commits

Conventional Commits are recommended:

```text
feat: add local JSON input
fix: preserve CIDR prefix during conversion
docs: clarify platform requirements
test: cover duplicate CIDR entries
chore: update GitHub workflow
```

## Local checks

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

macOS and Linux:

```bash
bash ./tests/run-tests.sh
```

## Pull requests

Describe:

- the problem being solved;
- how to verify the result;
- affected platforms;
- whether both implementations are synchronized;
- whether Russian and English messages are synchronized;
- whether documentation needs to be updated.

Do not commit private configurations, keys, tokens, personal server addresses, or generated route lists.

[Advanced usage: CLI, TUI, source and tests](guides/advanced-usage.md) · [Security policy](SECURITY.md)
