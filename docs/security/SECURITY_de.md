# Sicherheit

## Sprache auswählen

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/SECURITY.md) | [English](./SECURITY_en.md) | [Español](./SECURITY_es.md) | [中文](./SECURITY_zh.md) | [Français](./SECURITY_fr.md) | **Ausgewählt** |

Dies ist ein kleines Projekt, das von einer Person gepflegt wird. Wenn Sie ein Sicherheitsproblem finden, melden Sie es bitte, ohne die Details vor einer verfügbaren Korrektur öffentlich zu machen.

## Was besser privat gemeldet wird

- Ausführung beliebiger Befehle über eine URL, einen Pfad oder ein Argument;
- Umgehung der HTTPS- oder `iplist.opencck.org`-Prüfung;
- Schreiben des Ergebnisses an einen vom Benutzer nicht gewählten Pfad;
- Hinzufügen von Routen, die nicht in den Eingabedaten enthalten waren;
- Manipulation oder unsichere Veröffentlichung eines Release-Archivs.

Normale Konvertierungsfehler, Nutzungsfragen und Funktionswünsche können in [Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues) oder [Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions) veröffentlicht werden.

## Meldung

Bevorzugt wird GitHub Private Vulnerability Reporting:

1. Öffnen Sie **Security and quality**.
2. Wechseln Sie zu **Advisories**.
3. Klicken Sie auf **Report a vulnerability**.
4. Beschreiben Sie das Problem, ohne ein öffentliches Issue zu erstellen.

Wenn das private Formular nicht verfügbar ist, erstellen Sie ein kurzes öffentliches Issue ohne Exploit-Code oder sensible Details und bitten Sie um einen privaten Kontaktweg.

## Sinnvolle Angaben

Wenn möglich, nennen Sie:

- Release-Version oder commit SHA;
- Betriebssystem und Laufzeitumgebung;
- eine kurze Beschreibung der Auswirkung;
- minimale Schritte zur Reproduktion;
- anonymisierte Beispieldaten.

Veröffentlichen Sie keine Schlüssel, Tokens, privaten Konfigurationen oder Adressen persönlicher Server.

## Weitere Bearbeitung

Ich werde versuchen, den Bericht zu bestätigen, das Problem zu reproduzieren und eine Korrektur vorzubereiten. Das Projekt hat weder ein garantiertes SLA noch ein Prämienprogramm. Technische Details sollten bis zur Veröffentlichung einer Korrektur abgestimmt werden.
