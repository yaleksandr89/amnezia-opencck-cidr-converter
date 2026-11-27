# Erweiterte Verwendung

## Sprache auswählen

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../ru/guides/advanced-usage.md) | [English](../../en/guides/advanced-usage.md) | [Español](../../es/guides/advanced-usage.md) | [中文](../../zh/guides/advanced-usage.md) | [Français](../../fr/guides/advanced-usage.md) | **Ausgewählt** |

Dieser Leitfaden enthält Startparameter, manuelle Sprachauswahl, direkten Start der Quelldateien, Projektstruktur und Entwicklungsbefehle.

## Start aus dem Quellcode

Klonen Sie das Repository und wechseln Sie in dessen Stammverzeichnis. Führen Sie die folgenden Befehle dort aus.

```bash
git clone https://github.com/yaleksandr89/amnezia-opencck-cidr-converter.git
cd amnezia-opencck-cidr-converter
```

Windows: Windows PowerShell 5.1 (die CLI unterstützt auch PowerShell 7). Linux/macOS: Bash, AWK und Standard-Systemprogramme; der URL-Modus benötigt `curl` oder `wget`. Fertige Pakete enthalten `gum` 0.17.0; die TUI aus dem Quellcode benötigt `gum` in PATH.

## Interaktive TUI

Fertige Pakete öffnen automatisch die TUI.

Die TUI ermöglicht die Auswahl der Quelle (URL oder lokale JSON-Datei), des Ausgabeordners und der Sprache sowie erneute Konvertierung und das Öffnen des Ausgabeordners.

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr-ui.ps1
```

Linux/macOS:

```bash
bash ./src/convert-opencck-cidr-ui.sh
```

Wählen Sie einen anderen Ausgabepfad als die Eingabe-JSON-Datei. Eine erfolgreiche Konvertierung ersetzt eine vorhandene Ausgabedatei. Prüfen Sie die Routen vor dem Import.

## Sprache der Oberfläche

Standardmäßig wird `auto` verwendet:

- Windows nutzt die aktuelle UI-Kultur;
- macOS und Linux nutzen `LC_ALL`, `LC_MESSAGES` oder `LANG`;
- Englisch wird verwendet, wenn keine russische Locale erkannt wird.

Unterstützte Werte:

```text
auto
ru
en
```

Windows:

```powershell
.\bin\convert-opencck-cidr.cmd -Language en
```

macOS und Linux:

```bash
./bin/convert-opencck-cidr.sh --language en
```

## Parametrisierter Start

Die Beispiel-URLs sind gekürzt: Ersetzen Sie `https://iplist.opencck.org/?...` durch die vollständige OpenCCK-URL aus Ihrem Browser.

### Windows

```powershell
.\bin\convert-opencck-cidr.cmd `
  -SourceUrl "https://iplist.opencck.org/?..." `
  -OutputPath ".\routes.json" `
  -Language en
```

Lokale JSON-Datei:

```powershell
.\bin\convert-opencck-cidr.cmd `
  -InputPath ".\input.json" `
  -OutputPath ".\routes.json"
```

Parameter:

| Parameter | Zweck |
|---|---|
| `-SourceUrl` | OpenCCK-URL |
| `-InputPath` | Lokale JSON-Datei im OpenCCK-Format |
| `-OutputPath` | Pfad zur Ausgabe-JSON |
| `-Language` | `auto`, `ru` oder `en` |
| `-PassThru` | `Success`, `RouteCount`, `OutputPath`, `ErrorMessage` (`src/convert-opencck-cidr.ps1`) |

### macOS und Linux

```bash
./bin/convert-opencck-cidr.sh \
  --source-url 'https://iplist.opencck.org/?...' \
  --output-path './routes.json' \
  --language en
```

Lokale JSON-Datei:

```bash
./bin/convert-opencck-cidr.sh \
  --input-path './input.json' \
  --output-path './routes.json'
```

Parameter:

| Parameter | Zweck |
|---|---|
| `--source-url`, `-u` | OpenCCK-URL |
| `--input-path`, `-i` | Lokale JSON-Datei im OpenCCK-Format |
| `--output-path`, `-o` | Pfad zur Ausgabe-JSON |
| `--language`, `-l` | `auto`, `ru` oder `en` |
| `--machine-readable` | Maschinenlesbare Ausgabe für TUI und Integrationen |
| `--help`, `-h` | Hilfe anzeigen |

Wenn kein Ausgabepfad angegeben ist, wird das Ergebnis im Projektstamm gespeichert:

```text
amnezia-opencck-cidr.json
```

## Direkter Start der Quelldateien

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr.ps1 `
  -Language en
```

### macOS und Linux

```bash
bash ./src/convert-opencck-cidr.sh --language en
```

## Projektstruktur

```text
.
├── bin/
│   ├── convert-opencck-cidr.cmd
│   └── convert-opencck-cidr.sh
├── src/
│   ├── convert-opencck-cidr.ps1
│   ├── convert-opencck-cidr.sh
│   ├── convert-opencck-cidr-ui.ps1
│   ├── convert-opencck-cidr-ui.sh
│   ├── lib/
│   └── ui/
├── build/
│   ├── windows/
│   └── unix/
├── tests/
├── docs/
│   ├── assets/
│   └── langs/
├── .github/
├── AGENTS.md
├── LICENSE
└── README.md
```

## Entwicklung

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### macOS und Linux

```bash
bash ./tests/run-tests.sh
```

GitHub Actions führt native Tests unter Windows, Ubuntu und macOS aus, baut Standalone-Pakete und speichert sie als CI-Artefakte.

Bauen Sie in einer separaten Arbeitskopie: Die Skripte ersetzen ihre Verzeichnisse und Archive in `dist/` und laden `gum` mit SHA-256-Prüfung herunter.

[gum-Lizenz (MIT)](../../../../build/windows/third-party/GUM-LICENSE.txt).

[Mitwirken](../CONTRIBUTING.md) · [Sicherheitsrichtlinie](../SECURITY.md) · [README](../README.md)
