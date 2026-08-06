# Contribuer au projet

## Choisissez une langue

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/CONTRIBUTING.md) | [English](./CONTRIBUTING_en.md) | [Español](./CONTRIBUTING_es.md) | [中文](./CONTRIBUTING_zh.md) | **Sélectionné** | [Deutsch](./CONTRIBUTING_de.md) |

Merci de votre intérêt pour le projet.

## Avant de commencer

- Créez une Issue pour un problème reproductible.
- Utilisez la catégorie Q&A de Discussions pour les questions d’utilisation.
- Discutez des changements importants avant de les implémenter.

## Implémentations

Le projet contient deux implémentations natives du même comportement :

- `src/convert-opencck-cidr.ps1` — Windows ;
- `src/convert-opencck-cidr.sh` — macOS et Linux.

Les changements de logique de conversion doivent être appliqués aux deux implémentations, sauf si une différence propre à une plateforme est explicitement justifiée.

Les messages destinés aux utilisateurs sont disponibles en russe et en anglais. Mettez à jour les deux localisations lors de l’ajout ou de la modification d’un message.

## Branches

```text
feature/add-cidr6-support
fix/windows-path-handling
docs/update-linux-guide
```

## Commits

Le format Conventional Commits est recommandé :

```text
feat: add local JSON input
fix: preserve CIDR prefix during conversion
docs: clarify platform requirements
test: cover duplicate CIDR entries
chore: update GitHub workflow
```

## Vérification locale

Windows :

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

macOS et Linux :

```bash
./tests/run-tests.sh
```

## Pull requests

Décrivez :

- le problème résolu par le changement ;
- la méthode de vérification ;
- les plateformes concernées ;
- si les deux implémentations sont synchronisées ;
- si les messages russes et anglais sont synchronisés ;
- si la documentation doit être mise à jour.

N’ajoutez pas de configurations privées, clés, jetons, adresses de serveurs personnels ou listes de routes générées.
