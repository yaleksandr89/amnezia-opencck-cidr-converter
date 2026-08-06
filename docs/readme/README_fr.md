# Amnezia OpenCCK CIDR Converter

[![CI](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml/badge.svg)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-brightgreen.svg)](../../LICENSE)

## Choisissez une langue

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../README.md) | [English](./README_en.md) | [Español](./README_es.md) | [中文](./README_zh.md) | **Sélectionné** | [Deutsch](./README_de.md) |

Convertit les listes IPv4 CIDR d’OpenCCK en JSON afin de les importer correctement dans AmneziaVPN 5.x.

Le projet ne modifie pas le client et ne constitue pas un correctif du client. Il transforme la liste avant l’importation.

> [!IMPORTANT]
> Il s’agit d’une solution temporaire à un problème d’importation CIDR, et non d’un format officiel d’AmneziaVPN. Le projet n’est affilié ni à l’équipe AmneziaVPN ni à l’équipe OpenCCK.

## Problème

OpenCCK peut renvoyer une valeur CIDR dans le champ `hostname` :

```json
{
  "hostname": "142.250.0.0/15",
  "ip": ""
}
```

Lors d’une importation problématique, le préfixe de sous-réseau peut être perdu. Le convertisseur déplace la valeur CIDR vers le champ `ip` et crée un nom de service unique :

```json
{
  "hostname": "route-000001.invalid",
  "ip": "142.250.0.0/15"
}
```

La route réelle est enregistrée dans `ip`. Le nom sous le domaine `.invalid` sert uniquement de clé unique pour l’enregistrement.

## Fonctionnement du convertisseur

1. Accepte une URL générée sur `iplist.opencck.org`.
2. Vérifie HTTPS, le domaine, le format `Amnezia` et le type de données `IPv4 CIDR`.
3. Télécharge la liste JSON actuelle.
4. Valide les entrées IPv4 CIDR.
5. Supprime les doublons tout en conservant l’ordre d’origine.
6. Déplace les valeurs CIDR de `hostname` vers `ip`.
7. Génère des noms séquentiels tels que `route-000001.invalid`.
8. Écrit le résultat au format JSON UTF-8 sans BOM.

Les deux implémentations peuvent également convertir un fichier JSON local pour le développement et les tests automatisés.

## Structure du projet

```text
bin/                   lanceurs destinés aux utilisateurs
src/                   implémentations natives pour Windows et les systèmes Unix
tests/                 tests et données de test
docs/readme/           traductions du README
docs/contributing/     traductions du guide de contribution
docs/security/         traductions de la politique de sécurité
.github/               CI, modèles et fichiers communautaires GitHub
```

## Systèmes pris en charge

| Système | Lanceur | Prérequis |
|---|---|---|
| Windows 10/11 | `bin/convert-opencck-cidr.cmd` | Windows PowerShell 5.1 ou PowerShell 7 |
| macOS | `bin/convert-opencck-cidr.sh` | Bash et `curl` ou `wget` |
| Linux | `bin/convert-opencck-cidr.sh` | Bash et `curl` ou `wget` |

Il n’est pas nécessaire d’installer Python ou PowerShell sous macOS ou Linux. Windows utilise PowerShell, tandis que macOS et Linux utilisent l’implémentation Bash native.

## Langue de l’interface

Le convertisseur prend en charge les interfaces russe et anglaise.

La valeur par défaut est `auto` :

- Windows utilise la culture d’interface actuelle ;
- macOS et Linux utilisent `LC_ALL`, `LC_MESSAGES` ou `LANG` ;
- l’anglais est utilisé lorsqu’aucune locale russe n’est détectée.

La langue peut aussi être indiquée explicitement.

Windows :

```powershell
.\bin\convert-opencck-cidr.cmd `
  -Language en
```

macOS et Linux :

```bash
./bin/convert-opencck-cidr.sh --language en
```

Valeurs acceptées : `auto`, `ru`, `en`.

## Démarrage rapide

### 1. Préparer une URL OpenCCK

1. Ouvrez [iplist.opencck.org](https://iplist.opencck.org/).
2. Sélectionnez les sites et services nécessaires.
3. Sélectionnez le format **Amnezia**.
4. Sélectionnez les **plages IPv4 CIDR** comme type de données.
5. Désactivez **Enregistrer comme fichier**.
6. Copiez l’URL longue dans le champ situé en bas de la page.

### 2. Exécuter le convertisseur

#### Windows

Double-cliquez sur :

```text
bin/convert-opencck-cidr.cmd
```

Ou transmettez les paramètres depuis un terminal :

```powershell
.\bin\convert-opencck-cidr.cmd `
  -SourceUrl "https://iplist.opencck.org/?..." `
  -OutputPath ".\routes.json" `
  -Language en
```

#### macOS et Linux

Autorisez l’exécution une fois :

```bash
chmod +x ./bin/convert-opencck-cidr.sh
```

Mode interactif :

```bash
./bin/convert-opencck-cidr.sh
```

Ou transmettez directement les paramètres :

```bash
./bin/convert-opencck-cidr.sh \
  --source-url 'https://iplist.opencck.org/?...' \
  --output-path './routes.json' \
  --language en
```

Si aucun chemin de sortie n’est fourni, le fichier suivant est créé à la racine du projet :

```text
amnezia-opencck-cidr.json
```

Importez le JSON généré dans l’application.

## Exécution directe des implémentations

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr.ps1 `
  -Language en
```

Paramètres : `-SourceUrl`, `-InputPath`, `-OutputPath`, `-Language`.

### macOS et Linux

```bash
bash ./src/convert-opencck-cidr.sh --language en
```

Paramètres : `--source-url`, `--input-path`, `--output-path`, `--language`.

## Limitations

- Seul IPv4 CIDR (`data=cidr4`) est pris en charge.
- Les téléchargements réseau n’acceptent que les URL HTTPS du domaine `iplist.opencck.org`.
- Le mode réseau dépend de la disponibilité et du format de réponse d’OpenCCK.
- **Le convertisseur peut devenir inutile une fois le problème d’importation corrigé dans le client officiel.**

## Développement

### Tests sous Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### Tests sous macOS et Linux

```bash
chmod +x ./tests/run-tests.sh
./tests/run-tests.sh
```

GitHub Actions exécute les tests natifs séparément sous Windows, Ubuntu et macOS.

Les règles de contribution sont disponibles dans [CONTRIBUTING.md](../contributing/CONTRIBUTING_fr.md).

## Retour d’expérience

- erreurs reproductibles — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues) ;
- questions et idées — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

---

<p align="center">
  Si cet outil vous a aidé, ajoutez une étoile au dépôt afin que d’autres développeurs puissent le trouver. 🤘
</p>
