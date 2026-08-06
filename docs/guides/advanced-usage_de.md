# Erweiterte Verwendung

## Sprache auswählen

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](./advanced-usage.md) | [English](./advanced-usage_en.md) | [Español](./advanced-usage_es.md) | [中文](./advanced-usage_zh.md) | [Français](./advanced-usage_fr.md) | **Ausgewählt** |

Dieser Leitfaden enthält Startparameter, manuelle Sprachauswahl, direkten Start der Quelldateien, Projektstruktur und Entwicklungsbefehle.

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
│   └── convert-opencck-cidr.sh
├── tests/
│   ├── fixtures/
│   │   ├── expected-output.json
│   │   └── opencck-sample.json
│   ├── run-tests.ps1
│   └── run-tests.sh
├── docs/
│   ├── contributing/
│   ├── guides/
│   ├── readme/
│   └── security/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── workflows/
│   ├── CONTRIBUTING.md
│   ├── FUNDING.yml
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── SECURITY.md
├── .editorconfig
├── .gitattributes
├── .gitignore
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
chmod +x ./tests/run-tests.sh
./tests/run-tests.sh
```

GitHub Actions führt native Tests getrennt unter Windows, Ubuntu und macOS aus.

Die Regeln für Beiträge stehen in [CONTRIBUTING.md](../contributing/CONTRIBUTING_de.md).
