# Amnezia OpenCCK CIDR Converter

[![CI](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml/badge.svg)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-brightgreen.svg)](../../LICENSE)

## Sprache auswählen

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../README.md) | [English](./README_en.md) | [Español](./README_es.md) | [中文](./README_zh.md) | [Français](./README_fr.md) | **Ausgewählt** |

Konvertiert IPv4-CIDR-Listen von OpenCCK in JSON, das korrekt in AmneziaVPN 5.x importiert werden kann.

Das Projekt verändert oder patcht den Client nicht. Es wandelt die Liste vor dem Import um.

> [!IMPORTANT]
> Dies ist eine vorübergehende Lösung für ein CIDR-Importproblem und kein offizielles AmneziaVPN-Format. Das Projekt steht in keiner Verbindung zu den Teams von AmneziaVPN oder OpenCCK.

## Problem

OpenCCK kann einen CIDR-Wert im Feld `hostname` zurückgeben:

```json
{
  "hostname": "142.250.0.0/15",
  "ip": ""
}
```

Bei einem fehlerhaften Import kann das Subnetzpräfix verloren gehen. Der Konverter verschiebt den CIDR-Wert in das Feld `ip` und erzeugt einen eindeutigen Dienstnamen:

```json
{
  "hostname": "route-000001.invalid",
  "ip": "142.250.0.0/15"
}
```

Die eigentliche Route wird in `ip` gespeichert. Der Name unter `.invalid` dient ausschließlich als eindeutiger Schlüssel des Eintrags.

## Funktionsweise des Konverters

1. Übernimmt eine auf `iplist.opencck.org` erzeugte URL.
2. Prüft HTTPS, die Domain, das Format `Amnezia` und den Datentyp `IPv4 CIDR`.
3. Lädt die aktuelle JSON-Liste herunter.
4. Validiert IPv4-CIDR-Einträge.
5. Entfernt Duplikate und behält die ursprüngliche Reihenfolge bei.
6. Verschiebt CIDR-Werte von `hostname` nach `ip`.
7. Erzeugt fortlaufende Namen wie `route-000001.invalid`.
8. Schreibt das Ergebnis als UTF-8-JSON ohne BOM.

Beide Implementierungen können außerdem eine lokale JSON-Datei für Entwicklung und automatisierte Tests konvertieren.

## Projektstruktur

```text
bin/                   benutzerseitige Starter
src/                   native Implementierungen für Windows und Unix-Systeme
tests/                 Tests und Testdaten
docs/readme/           README-Übersetzungen
docs/contributing/     Übersetzungen der Beitragsrichtlinien
docs/security/         Übersetzungen der Sicherheitsrichtlinie
.github/               CI, Vorlagen und GitHub-Community-Dateien
```

## Unterstützte Systeme

| System | Starter | Anforderungen |
|---|---|---|
| Windows 10/11 | `bin/convert-opencck-cidr.cmd` | Windows PowerShell 5.1 oder PowerShell 7 |
| macOS | `bin/convert-opencck-cidr.sh` | Bash und `curl` oder `wget` |
| Linux | `bin/convert-opencck-cidr.sh` | Bash und `curl` oder `wget` |

Unter macOS und Linux müssen weder Python noch PowerShell zusätzlich installiert werden. Windows verwendet PowerShell, macOS und Linux verwenden die native Bash-Implementierung.

## Sprache der Benutzeroberfläche

Der Konverter unterstützt eine russische und eine englische Oberfläche.

Der Standardwert ist `auto`:

- Windows verwendet die aktuelle UI-Kultur;
- macOS und Linux verwenden `LC_ALL`, `LC_MESSAGES` oder `LANG`;
- Englisch wird verwendet, wenn keine russische Locale erkannt wird.

Die Sprache kann auch ausdrücklich angegeben werden.

Windows:

```powershell
.\bin\convert-opencck-cidr.cmd `
  -Language en
```

macOS und Linux:

```bash
./bin/convert-opencck-cidr.sh --language en
```

Zulässige Werte: `auto`, `ru`, `en`.

## Schnellstart

### 1. OpenCCK-URL vorbereiten

1. Öffnen Sie [iplist.opencck.org](https://iplist.opencck.org/).
2. Wählen Sie die benötigten Websites und Dienste aus.
3. Wählen Sie das Format **Amnezia**.
4. Wählen Sie **IPv4-CIDR-Bereiche** als Datentyp.
5. Deaktivieren Sie **Als Datei speichern**.
6. Kopieren Sie die lange URL aus dem Feld am unteren Seitenrand.

### 2. Konverter starten

#### Windows

Doppelklicken Sie auf:

```text
bin/convert-opencck-cidr.cmd
```

Oder übergeben Sie die Parameter im Terminal:

```powershell
.\bin\convert-opencck-cidr.cmd `
  -SourceUrl "https://iplist.opencck.org/?..." `
  -OutputPath ".\routes.json" `
  -Language en
```

#### macOS und Linux

Erteilen Sie einmalig die Ausführungsberechtigung:

```bash
chmod +x ./bin/convert-opencck-cidr.sh
```

Interaktiver Modus:

```bash
./bin/convert-opencck-cidr.sh
```

Oder übergeben Sie die Parameter direkt:

```bash
./bin/convert-opencck-cidr.sh \
  --source-url 'https://iplist.opencck.org/?...' \
  --output-path './routes.json' \
  --language en
```

Wenn kein Ausgabepfad angegeben wird, wird im Projektstamm die folgende Datei erstellt:

```text
amnezia-opencck-cidr.json
```

Importieren Sie das erzeugte JSON in die Anwendung.

## Implementierungen direkt ausführen

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr.ps1 `
  -Language en
```

Parameter: `-SourceUrl`, `-InputPath`, `-OutputPath`, `-Language`.

### macOS und Linux

```bash
bash ./src/convert-opencck-cidr.sh --language en
```

Parameter: `--source-url`, `--input-path`, `--output-path`, `--language`.

## Einschränkungen

- Es wird ausschließlich IPv4 CIDR (`data=cidr4`) unterstützt.
- Netzwerkdownloads akzeptieren nur HTTPS-URLs der Domain `iplist.opencck.org`.
- Der Netzwerkmodus hängt von der Verfügbarkeit und dem Antwortformat von OpenCCK ab.
- **Nach einer Korrektur des Importproblems im offiziellen Client wird der Konverter möglicherweise nicht mehr benötigt.**

## Entwicklung

### Tests unter Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### Tests unter macOS und Linux

```bash
chmod +x ./tests/run-tests.sh
./tests/run-tests.sh
```

GitHub Actions führt native Tests getrennt unter Windows, Ubuntu und macOS aus.

Die Beitragsrichtlinien finden Sie in [CONTRIBUTING.md](../contributing/CONTRIBUTING_de.md).

## Rückmeldung

- reproduzierbare Fehler — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues);
- Fragen und Ideen — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

---

<p align="center">
  Wenn dieses Tool geholfen hat, geben Sie dem Repository einen Stern, damit andere Entwickler es leichter finden. 🤘
</p>
