# Utilisation avancée

## Choisissez une langue

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](./advanced-usage.md) | [English](./advanced-usage_en.md) | [Español](./advanced-usage_es.md) | [中文](./advanced-usage_zh.md) | **Sélectionné** | [Deutsch](./advanced-usage_de.md) |

Ce guide regroupe les paramètres de lancement, le choix manuel de la langue, l’exécution directe des sources, la structure du projet et les commandes de développement.

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
├── bin/                     # точки запуска
│   ├── convert-opencck-cidr.cmd    # Windows
│   └── convert-opencck-cidr.sh     # macOS и Linux
├── src/                     # основная логика конвертера
│   ├── convert-opencck-cidr.ps1    # реализация для Windows
│   └── convert-opencck-cidr.sh     # реализация для macOS и Linux
├── tests/                   # автоматические тесты и тестовые данные
├── docs/
│   ├── readme/              # переводы README
│   ├── guides/              # расширенные инструкции
│   ├── contributing/        # переводы правил участия
│   └── security/            # переводы политики безопасности
├── .github/                 # CI, шаблоны Issues и Pull Request
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
chmod +x ./tests/run-tests.sh
./tests/run-tests.sh
```

GitHub Actions exécute les tests natifs séparément sous Windows, Ubuntu et macOS.

Les règles de contribution sont disponibles dans [CONTRIBUTING.md](../contributing/CONTRIBUTING_fr.md).
