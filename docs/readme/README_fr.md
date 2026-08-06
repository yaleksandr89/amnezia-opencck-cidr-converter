# Amnezia OpenCCK CIDR Converter

[![CI](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml/badge.svg)](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-brightgreen.svg)](../../LICENSE)

## Choisissez une langue

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../README.md) | [English](./README_en.md) | [Español](./README_es.md) | [中文](./README_zh.md) | **Sélectionné** | [Deutsch](./README_de.md) |

Convertit les listes IPv4 CIDR d’OpenCCK en JSON afin de les importer correctement dans AmneziaVPN 5.x.

Le projet ne modifie pas le client et ne constitue pas un correctif. Il transforme la liste avant l’importation.

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

Lors d’une importation problématique, le préfixe de sous-réseau peut être perdu. Le convertisseur crée une entrée où le CIDR est stocké dans `ip` :

```json
{
  "hostname": "route-000001.invalid",
  "ip": "142.250.0.0/15"
}
```

## Fonctionnement du convertisseur

- accepte une URL générée sur `iplist.opencck.org` ;
- valide et convertit les entrées IPv4 CIDR correctes ;
- supprime les doublons tout en conservant l’ordre d’origine ;
- crée `amnezia-opencck-cidr.json` à la racine du projet, prêt à être importé.

## Systèmes pris en charge

| Système | Lancement | Prérequis |
|---|---|---|
| Windows 10/11 | `bin/convert-opencck-cidr.cmd` | Windows PowerShell 5.1 ou PowerShell 7 |
| macOS | `bin/convert-opencck-cidr.sh` | Bash et `curl` ou `wget` |
| Linux | `bin/convert-opencck-cidr.sh` | Bash et `curl` ou `wget` |

## Démarrage rapide

### 1. Préparez l’URL OpenCCK

1. Ouvrez [iplist.opencck.org](https://iplist.opencck.org/).
2. Sélectionnez les sites et services nécessaires.
3. Choisissez le format **Amnezia**.
4. Choisissez les **plages IPv4 CIDR**.
5. Désactivez **Enregistrer dans un fichier**.
6. Copiez l’URL longue affichée en bas de la page.

### 2. Lancez le convertisseur

#### Windows

Double-cliquez sur :

```text
bin/convert-opencck-cidr.cmd
```

#### macOS et Linux

Autorisez l’exécution une seule fois :

```bash
chmod +x ./bin/convert-opencck-cidr.sh
```

Lancez :

```bash
./bin/convert-opencck-cidr.sh
```

La langue de l’interface est détectée automatiquement et peut être imposée lors d’un lancement paramétré.

Une fois l’exécution terminée, importez le JSON généré dans l’application.

Les paramètres, le choix de la langue, le lancement direct des sources, la structure du projet et les tests sont décrits dans le [guide d’utilisation avancée](../guides/advanced-usage_fr.md).

## Limites

- Seul IPv4 CIDR (`data=cidr4`) est pris en charge.
- Les téléchargements réseau n’acceptent que les URL HTTPS de `iplist.opencck.org`.
- Le mode réseau dépend de la disponibilité et du format de réponse d’OpenCCK.
- Le convertisseur peut devenir inutile lorsque le problème sera corrigé dans le client officiel.

## Documentation

- [Utilisation avancée](../guides/advanced-usage_fr.md)
- [Contribution](../contributing/CONTRIBUTING_fr.md)
- [Sécurité](../security/SECURITY_fr.md)

## Retours

- erreurs reproductibles — [GitHub Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues) ;
- questions et idées — [GitHub Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

---

<p align="center">
  Si cet outil vous a aidé, ajoutez une étoile au dépôt afin que d’autres développeurs puissent le trouver. 🤘
</p>
