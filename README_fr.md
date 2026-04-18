# Calagopus Panel pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/calagopus.svg)](https://dash.yunohost.org/appci/app/calagopus) ![Statut de fonctionnement](https://ci-apps.yunohost.org/ci/badges/calagopus.status.svg) ![Statut de maintenance](https://ci-apps.yunohost.org/ci/badges/calagopus.maintain.svg)

[![Installer Calagopus Panel avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=calagopus)

*[Read this readme in English.](./README.md)* | *[Bu benioku dosyasını Türkçe okuyun.](./README_tr.md)*

> *Ce package vous permet d'installer Calagopus Panel rapidement et simplement sur un serveur YunoHost. Si vous n'avez pas YunoHost, veuillez consulter [le guide](https://doc.yunohost.org/admin/get_started/install_on/) pour apprendre comment l'installer.*

## Vue d'ensemble

Calagopus Panel est une interface de gestion de serveurs de jeux open-source et auto-hébergée, construite avec Rust (backend) et React (frontend). Inspirée par Pterodactyl, elle offre une interface web moderne pour créer, gérer et surveiller les serveurs de jeux via des agents de nœuds Wings.

### Fonctionnalités
- Interface React moderne et réactive
- Backend Rust léger et performant
- Couche de données PostgreSQL et Valkey/Redis
- Gestion complète des serveurs de jeux (actions d'alimentation, console, fichiers)

**Version fournie :** 0.1~ynh1

## Avertissements / informations importantes

### Configuration initiale (OOBE)
Après l'installation, naviguez vers l'URL du panneau pour terminer l'assistant de configuration **Out-of-Box Experience (OOBE)**. Vous devez y créer votre compte administrateur initial avant que le panneau ne soit fonctionnel.

### Authentification
Calagopus Panel utilise son **propre système d'authentification intégré**. L'authentification unique (SSO) de YunoHost est intentionnellement désactivée. Vous ne pouvez pas vous connecter avec vos identifiants YunoHost.

### Nœuds de serveurs de jeux
Ce package installe **uniquement le panneau de contrôle**. Pour héberger des serveurs de jeux, vous devez installer et connecter séparément **Wings** (l'agent de nœud) sur les mêmes serveurs ou sur des serveurs différents. Consultez la [documentation de Wings](https://docs.calagopus.com/wings).

### Architecture et prérequis
- **Processeur** : Seules les architectures `amd64` (x86_64) et `arm64` (aarch64) sont prises en charge.
- **RAM** : 512 Mo minimum (1 Go recommandé).
- **Disque** : 1 Go d'espace libre.
- Une **seule installation** par serveur YunoHost est autorisée.

## Documentation et ressources
* Site web officiel de l'application : <https://calagopus.com>
* Documentation officielle d'administration : <https://docs.calagopus.com/panel>
* Dépôt de code de l'application en amont : <https://github.com/calagopus/panel>
* Signaler un bug : <https://github.com/YunoHost-Apps/calagopus_ynh/issues>

## Informations pour les développeurs

Pour essayer la branche de test, veuillez procéder comme suit.
``` bash
sudo yunohost app install https://github.com/YunoHost-Apps/calagopus_ynh/tree/testing --debug
ou
sudo yunohost app upgrade calagopus -u https://github.com/YunoHost-Apps/calagopus_ynh/tree/testing --debug
```
