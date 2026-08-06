# Politique de sécurité

## Choisissez une langue

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/SECURITY.md) | [English](./SECURITY_en.md) | [Español](./SECURITY_es.md) | [中文](./SECURITY_zh.md) | **Sélectionné** | [Deutsch](./SECURITY_de.md) |

## Versions prises en charge

Les correctifs de sécurité sont fournis pour la dernière version publiée du projet.

| Version | Prise en charge |
|---|---|
| Dernière version | Oui |
| Versions antérieures | Non |

## Ce qui constitue une vulnérabilité

Les problèmes de sécurité comprennent notamment :

- l’exécution de commandes arbitraires via une URL, un chemin ou un argument de ligne de commande ;
- le contournement de la validation HTTPS ou du domaine `iplist.opencck.org` ;
- l’écriture du résultat dans un emplacement inattendu sans demande explicite de l’utilisateur ;
- le traitement du contenu de la réponse OpenCCK comme du code exécutable ;
- la production d’un résultat ajoutant silencieusement des routes absentes des données d’entrée ;
- l’altération ou la publication non sécurisée d’une archive de version.

Les erreurs de conversion ordinaires, les questions d’utilisation et les demandes de fonctionnalités peuvent être publiées dans GitHub Issues ou Discussions si elles ne contiennent pas d’informations sensibles.

## Signaler une vulnérabilité

Utilisez de préférence GitHub Private Vulnerability Reporting lorsqu’il est disponible :

1. Ouvrez **Security and quality**.
2. Accédez à **Advisories**.
3. Sélectionnez **Report a vulnerability**.
4. Envoyez le rapport sans publier les détails techniques dans une Issue publique.

Si le signalement privé n’est pas disponible, créez une Issue publique minimale sans détails d’exploitation et demandez un canal de communication privé.

Ne publiez pas :

- un exploit fonctionnel ;
- des configurations privées de l’application ;
- des clés, mots de passe ou jetons ;
- des adresses de serveurs personnels ;
- toute autre information permettant une exploitation avant la publication d’un correctif.

## Contenu du rapport

Dans la mesure du possible, indiquez :

- la version publiée ou le commit SHA ;
- le système d’exploitation et la version de l’environnement : PowerShell ou Bash ;
- une description de l’impact ;
- les étapes minimales de reproduction ;
- le comportement attendu et le comportement réel ;
- un exemple d’entrée anonymisé ;
- une solution possible, si elle est connue.

## Traitement du rapport

Les rapports seront confirmés et examinés dans la mesure du possible. Aucun SLA fixe n’est garanti.

Veuillez coordonner la divulgation avec le mainteneur du projet avant de publier les détails. Le projet ne propose pas de programme de récompense pour les vulnérabilités.
