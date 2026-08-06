# Zum Projekt beitragen

## Sprache auswählen

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/CONTRIBUTING.md) | [English](./CONTRIBUTING_en.md) | [Español](./CONTRIBUTING_es.md) | [中文](./CONTRIBUTING_zh.md) | [Français](./CONTRIBUTING_fr.md) | **Ausgewählt** |

Vielen Dank für Ihr Interesse am Projekt.

## Vor dem Start

- Erstellen Sie für einen reproduzierbaren Fehler ein Issue.
- Verwenden Sie für Nutzungsfragen die Q&A-Kategorie in Discussions.
- Besprechen Sie größere Änderungen vor der Umsetzung.

## Implementierungen

Das Projekt enthält zwei native Implementierungen desselben Verhaltens:

- `src/convert-opencck-cidr.ps1` — Windows;
- `src/convert-opencck-cidr.sh` — macOS und Linux.

Änderungen an der Konvertierungslogik müssen in beiden Implementierungen vorgenommen werden, sofern ein plattformspezifischer Unterschied nicht ausdrücklich begründet ist.

Benutzermeldungen werden auf Russisch und Englisch unterstützt. Aktualisieren Sie beim Hinzufügen oder Ändern einer Meldung beide Lokalisierungen.

## Branches

```text
feature/add-cidr6-support
fix/windows-path-handling
docs/update-linux-guide
```

## Commits

Conventional Commits werden empfohlen:

```text
feat: add local JSON input
fix: preserve CIDR prefix during conversion
docs: clarify platform requirements
test: cover duplicate CIDR entries
chore: update GitHub workflow
```

## Lokale Prüfung

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

macOS und Linux:

```bash
./tests/run-tests.sh
```

## Pull Requests

Beschreiben Sie:

- das gelöste Problem;
- wie das Ergebnis geprüft werden kann;
- die betroffenen Plattformen;
- ob beide Implementierungen synchronisiert sind;
- ob russische und englische Meldungen synchronisiert sind;
- ob die Dokumentation aktualisiert werden muss.

Fügen Sie keine privaten Konfigurationen, Schlüssel, Tokens, persönlichen Serveradressen oder generierten Routenlisten hinzu.
