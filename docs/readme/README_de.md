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

Bei einem fehlerhaften Import kann das Subnetzpräfix verloren gehen. Der Konverter erstellt einen Eintrag, in dem der CIDR-Wert in `ip` gespeichert wird:

```json
{
  "hostname": "route-000001.invalid",
  "ip": "142.250.0.0/15"
}
```

## Was der Konverter macht

- akzeptiert eine auf `iplist.opencck.org` erzeugte URL;
- validiert und konvertiert gültige IPv4-CIDR-Einträge;
- entfernt Duplikate und behält die ursprüngliche Reihenfolge bei;
- erstellt im Projektstamm die importbereite Datei `amnezia-opencck-cidr.json`.

## Unterstützte Systeme

| System | Start | Voraussetzungen |
|---|---|---|
| Windows 10/11 | `bin/convert-opencck-cidr.cmd` | Windows PowerShell 5.1 oder PowerShell 7 |
| macOS | `bin/convert-opencck-cidr.sh` | Bash und `curl` oder `wget` |
| Linux | `bin/convert-opencck-cidr.sh` | Bash und `curl` oder `wget` |

## Schnellstart

### 1. OpenCCK-URL vorbereiten

1. Öffnen Sie [iplist.opencck.org](https://iplist.opencck.org/).
2. Wählen Sie die benötigten Websites und Dienste.
3. Wählen Sie das Format **Amnezia**.
4. Wählen Sie **IPv4-CIDR-Bereiche**.
5. Deaktivieren Sie **Als Datei speichern**.
6. Kopieren Sie die lange URL aus dem unteren Feld.

### 2. Konverter starten

#### Windows

Doppelklicken Sie auf:

```text
bin/convert-opencck-cidr.cmd
```

#### macOS und Linux

Erlauben Sie die Ausführung einmalig:

```bash
chmod +x ./bin/convert-opencck-cidr.sh
```

Starten Sie:

```bash
./bin/convert-opencck-cidr.sh
```

Die Sprache der Oberfläche wird automatisch erkannt und kann beim parametrisierten Start manuell festgelegt werden.

Importieren Sie anschließend die erzeugte JSON-Datei in die Anwendung.

Parameter, Sprachauswahl, direkter Start der Quelldateien, Projektstruktur und Tests sind im [Leitfaden zur erweiterten Verwendung](../guides/advanced-usage_de.md) beschrieben.

## Einschränkungen

- Es wird nur IPv4 CIDR (`data=cidr4`) unterstützt.
- Netzwerk-Downloads akzeptieren nur HTTPS-URLs von `iplist.opencck.org`.
- Der Netzwerkmodus hängt von der Verfügbarkeit und dem Antwortformat von OpenCCK ab.
- Nach einer Korrektur im offiziellen Client wird der Konverter möglicherweise nicht mehr benötigt.

## Dokumentation

- [Erweiterte Verwendung](../guides/advanced-usage_de.md)
- [Mitwirken](../contributing/CONTRIBUTING_de.md)
- [Sicherheit](../security/SECURITY_de.md)

## Rückmeldung

- reproduzierbare Fehler — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues);
- Fragen und Ideen — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

---

<p align="center">
  Wenn dieses Werkzeug geholfen hat, geben Sie dem Repository einen Stern, damit andere Entwickler es leichter finden. 🤘
</p>
