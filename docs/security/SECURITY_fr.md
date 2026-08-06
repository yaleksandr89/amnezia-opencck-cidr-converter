# Sécurité

## Choisissez une langue

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/SECURITY.md) | [English](./SECURITY_en.md) | [Español](./SECURITY_es.md) | [中文](./SECURITY_zh.md) | **Sélectionné** | [Deutsch](./SECURITY_de.md) |

Ce projet est petit et maintenu par une seule personne. Si vous trouvez un problème de sécurité, merci de le signaler sans publier les détails avant qu’un correctif soit disponible.

## Problèmes à signaler en privé

- exécution d’une commande arbitraire via une URL, un chemin ou un argument ;
- contournement de la validation HTTPS ou du domaine `iplist.opencck.org` ;
- écriture du résultat dans un chemin que l’utilisateur n’a pas choisi ;
- ajout de routes absentes des données d’entrée ;
- altération ou publication non sûre d’une archive de version.

Les erreurs de conversion ordinaires, les questions d’utilisation et les demandes de fonctionnalités peuvent être publiées dans [Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues) ou [Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

## Comment signaler

GitHub Private Vulnerability Reporting est la méthode recommandée :

1. Ouvrez **Security and quality**.
2. Accédez à **Advisories**.
3. Cliquez sur **Report a vulnerability**.
4. Décrivez le problème sans créer d’Issue publique.

Si le formulaire privé n’est pas disponible, créez une Issue courte sans exploit ni détails sensibles et demandez un canal de contact privé.

## Informations utiles

Dans la mesure du possible, indiquez :

- la version ou le commit SHA ;
- le système d’exploitation et l’environnement d’exécution ;
- une brève description de l’impact ;
- les étapes minimales de reproduction ;
- un exemple d’entrée anonymisé.

Ne publiez pas de clés, de jetons, de configurations privées ni d’adresses de serveurs personnels.

## Suite du traitement

J’essaierai de confirmer le rapport, de reproduire le problème et de préparer un correctif. Le projet ne garantit aucun SLA et ne propose pas de programme de récompense. Merci de coordonner la publication des détails techniques jusqu’à la disponibilité du correctif.
