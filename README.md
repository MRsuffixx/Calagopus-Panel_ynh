# Calagopus Panel for YunoHost

[![Integration level](https://dash.yunohost.org/integration/calagopus.svg)](https://dash.yunohost.org/appci/app/calagopus) ![Working status](https://ci-apps.yunohost.org/ci/badges/calagopus.status.svg) ![Maintenance status](https://ci-apps.yunohost.org/ci/badges/calagopus.maintain.svg)

[![Install Calagopus Panel with YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=calagopus)

*[Lire ce readme en français.](./README_fr.md)* | *[Bu benioku dosyasını Türkçe okuyun.](./README_tr.md)*

> *This package allows you to install Calagopus Panel quickly and simply on a YunoHost server. If you don't have YunoHost, please consult [the guide](https://doc.yunohost.org/admin/get_started/install_on/) to learn how to install it.*

## Overview

Calagopus Panel is an open-source, self-hosted game server management interface built with Rust (backend) and React (frontend). Inspired by Pterodactyl, it provides a modern web UI for creating, managing, and monitoring game servers through Wings node agents.

### Features
- Modern, responsive React-based interface
- Lightweight, high-performance Rust backend
- PostgreSQL and Valkey/Redis data layer
- Complete game server management (power actions, console, files)

**Shipped version:** 0.1~ynh1

## Disclaimers / important information

### First-Time Setup (OOBE)
After installation, navigate to the panel's URL to complete the **Out-of-Box Experience (OOBE)** setup wizard. You must create your initial administrator account here before the panel is functional.

### Authentication
Calagopus Panel uses its **own built-in authentication system**. YunoHost Single Sign-On (SSO) is intentionally disabled. You cannot log in with your YunoHost credentials.

### Game Server Nodes
This package installs **only the control panel**. To host game servers, you must separately install and connect **Wings** (the node agent) on the same or different servers. See the [Wings documentation](https://docs.calagopus.com/wings).

### Architecture & Requirements
- **CPU**: Only `amd64` (x86_64) and `arm64` (aarch64) architectures are supported.
- **RAM**: Minimum 512 MB (1 GB recommended).
- **Disk**: 1 GB free space.
- Only **one installation** per YunoHost server is allowed.

## Documentation and resources
* Official app website: <https://calagopus.com>
* Official admin documentation: <https://docs.calagopus.com/panel>
* Upstream app code repository: <https://github.com/calagopus/panel>
* Report a bug: <https://github.com/YunoHost-Apps/calagopus_ynh/issues>

## Developer info

To try the testing branch, please proceed like that.
``` bash
sudo yunohost app install https://github.com/YunoHost-Apps/calagopus_ynh/tree/testing --debug
or
sudo yunohost app upgrade calagopus -u https://github.com/YunoHost-Apps/calagopus_ynh/tree/testing --debug
```
