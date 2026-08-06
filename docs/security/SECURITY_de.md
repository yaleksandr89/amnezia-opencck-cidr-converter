# Sicherheitsrichtlinie

## Sprache auswählen

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/SECURITY.md) | [English](./SECURITY_en.md) | [Español](./SECURITY_es.md) | [中文](./SECURITY_zh.md) | [Français](./SECURITY_fr.md) | **Ausgewählt** |

## Unterstützte Versionen

Sicherheitskorrekturen werden für die zuletzt veröffentlichte Version des Projekts bereitgestellt.

| Version | Unterstützt |
|---|---|
| Neueste Version | Ja |
| Ältere Versionen | Nein |

## Was als Sicherheitslücke gilt

Zu Sicherheitsproblemen zählen insbesondere:

- die Ausführung beliebiger Befehle über eine URL, einen Pfad oder ein Kommandozeilenargument;
- das Umgehen der HTTPS- oder Domainprüfung für `iplist.opencck.org`;
- das Schreiben der Ausgabe an einen unerwarteten Ort ohne ausdrückliche Benutzeranforderung;
- die Behandlung des OpenCCK-Antwortinhalts als ausführbaren Code;
- die Erzeugung einer Ausgabe, die unbemerkt Routen hinzufügt, die in den Eingabedaten nicht vorhanden waren;
- die Manipulation oder unsichere Veröffentlichung eines Release-Archivs.

Normale Konvertierungsfehler, Nutzungsfragen und Funktionswünsche können in GitHub Issues oder Discussions veröffentlicht werden, sofern sie keine sensiblen Informationen enthalten.

## Sicherheitslücke melden

Verwenden Sie nach Möglichkeit GitHub Private Vulnerability Reporting:

1. Öffnen Sie **Security and quality**.
2. Wechseln Sie zu **Advisories**.
3. Wählen Sie **Report a vulnerability**.
4. Senden Sie den Bericht, ohne technische Details in einem öffentlichen Issue zu veröffentlichen.

Wenn private Meldungen nicht verfügbar sind, erstellen Sie ein minimales öffentliches Issue ohne Exploitationsdetails und bitten Sie um einen privaten Kommunikationskanal.

Veröffentlichen Sie nicht:

- einen funktionsfähigen Exploit;
- private Anwendungskonfigurationen;
- Schlüssel, Passwörter oder Tokens;
- persönliche Serveradressen;
- andere Informationen, die eine Ausnutzung vor Veröffentlichung einer Korrektur ermöglichen könnten.

## Inhalt des Berichts

Geben Sie nach Möglichkeit Folgendes an:

- die Release-Version oder commit SHA;
- das Betriebssystem und die Laufzeitversion: PowerShell oder Bash;
- eine Beschreibung der Auswirkungen;
- minimale Schritte zur Reproduktion;
- erwartetes und tatsächliches Verhalten;
- ein bereinigtes Eingabebeispiel;
- eine mögliche Korrektur, sofern bekannt.

## Bearbeitung des Berichts

Berichte werden nach Möglichkeit bestätigt und geprüft. Eine feste SLA wird nicht garantiert.

Stimmen Sie die Veröffentlichung von Details vorab mit dem Projektmaintainer ab. Das Projekt bietet kein Prämienprogramm für Sicherheitslücken.
