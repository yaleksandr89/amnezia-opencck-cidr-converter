# Utilisation avancée

## Choisissez une langue

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../ru/guides/advanced-usage.md) | [English](../../en/guides/advanced-usage.md) | [Español](../../es/guides/advanced-usage.md) | [中文](../../zh/guides/advanced-usage.md) | **Sélectionné** | [Deutsch](../../de/guides/advanced-usage.md) |

Ce guide regroupe les paramètres de lancement, le choix manuel de la langue, l’exécution directe des sources, la structure du projet et les commandes de développement.

## Exécution depuis les sources

Clonez le dépôt et placez-vous à sa racine. Exécutez les commandes ci-dessous depuis ce dossier.

```bash
git clone https://github.com/yaleksandr89/amnezia-opencck-cidr-converter.git
cd amnezia-opencck-cidr-converter
```

Windows : Windows PowerShell 5.1 (la CLI prend aussi en charge PowerShell 7). Linux/macOS : Bash, AWK et outils système standard ; le mode URL nécessite `curl` ou `wget`. Les paquets incluent `gum` 0.17.0 ; le TUI depuis les sources requiert `gum` dans PATH.

## TUI interactif

Les paquets prêts à utiliser ouvrent automatiquement le TUI.

Le TUI permet de choisir la source (URL ou JSON local), le dossier de sortie et la langue, de répéter la conversion et d’ouvrir le dossier de sortie.

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr-ui.ps1
```

Linux/macOS:

```bash
bash ./src/convert-opencck-cidr-ui.sh
```

Choisissez un chemin de sortie différent du JSON d’entrée. Une conversion réussie remplace le fichier de sortie existant. Vérifiez les routes avant de les importer.

## Langue de l’interface

Le mode par défaut est `auto` :

- Windows utilise la culture actuelle de l’interface ;
- macOS et Linux utilisent `LC_ALL`, `LC_MESSAGES` ou `LANG` ;
- l’anglais est utilisé lorsqu’aucune locale russe n’est détectée.

Valeurs prises en charge :

```text
auto
ru
en
```

Windows :

```powershell
.\bin\convert-opencck-cidr.cmd -Language en
```

macOS et Linux :

```bash
./bin/convert-opencck-cidr.sh --language en
```

## Lancement paramétré

Les URL d’exemple sont abrégées : remplacez `https://iplist.opencck.org/?...` par l’URL OpenCCK complète copiée depuis votre navigateur.

### Windows

```powershell
.\bin\convert-opencck-cidr.cmd `
  -SourceUrl "https://iplist.opencck.org/?..." `
  -OutputPath ".\routes.json" `
  -Language en
```

JSON local :

```powershell
.\bin\convert-opencck-cidr.cmd `
  -InputPath ".\input.json" `
  -OutputPath ".\routes.json"
```

Paramètres :

| Paramètre | Rôle |
|---|---|
| `-SourceUrl` | URL OpenCCK |
| `-InputPath` | JSON local au format OpenCCK |
| `-OutputPath` | Chemin du JSON de sortie |
| `-Language` | `auto`, `ru` ou `en` |
| `-PassThru` | `Success`, `RouteCount`, `OutputPath`, `ErrorMessage` (`src/convert-opencck-cidr.ps1`) |

### macOS et Linux

```bash
./bin/convert-opencck-cidr.sh \
  --source-url 'https://iplist.opencck.org/?...' \
  --output-path './routes.json' \
  --language en
```

JSON local :

```bash
./bin/convert-opencck-cidr.sh \
  --input-path './input.json' \
  --output-path './routes.json'
```

Paramètres :

| Paramètre | Rôle |
|---|---|
| `--source-url`, `-u` | URL OpenCCK |
| `--input-path`, `-i` | JSON local au format OpenCCK |
| `--output-path`, `-o` | Chemin du JSON de sortie |
| `--language`, `-l` | `auto`, `ru` ou `en` |
| `--machine-readable` | Sortie lisible par machine pour le TUI et les intégrations |
| `--help`, `-h` | Afficher l’aide |

Si aucun chemin de sortie n’est fourni, le résultat est enregistré à la racine du projet :

```text
amnezia-opencck-cidr.json
```

## Exécution directe des sources

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\src\convert-opencck-cidr.ps1 `
  -Language en
```

### macOS et Linux

```bash
bash ./src/convert-opencck-cidr.sh --language en
```

## Structure du projet

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

## Développement

### Windows

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

### macOS et Linux

```bash
bash ./tests/run-tests.sh
```

GitHub Actions CI exécute les tests natifs sous Windows, Ubuntu et macOS. Les compilations sont séparées : ouvrez [Actions → Standalone](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/standalone.yml), cliquez sur **Run workflow** et choisissez une branche et `targets` (une ou plusieurs plateformes ou `all`). Pour une version complète, choisissez `master` avec un CI réussi et `all`. Téléchargez les archives depuis la section Artifacts de cette exécution, puis extrayez les paquets prêts à l’emploi des ZIP externes. Le workflow ne publie pas automatiquement de version.

Construisez dans une copie séparée : les scripts remplacent leurs dossiers et archives dans `dist/` et téléchargent `gum` avec vérification SHA-256.

[Licence de gum (MIT)](../../../../build/windows/third-party/GUM-LICENSE.txt).

[Contribuer](../CONTRIBUTING.md) · [Politique de sécurité](../SECURITY.md) · [README](../README.md)
