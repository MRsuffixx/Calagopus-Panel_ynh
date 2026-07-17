# Calagopus Panel for YunoHost

[![Integration level](https://dash.yunohost.org/integration/calagopus-panel.svg)](https://dash.yunohost.org/appci/app/calagopus-panel)
[![Install Calagopus Panel with YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=calagopus-panel)

*[Lire ce readme en français.](./README_fr.md)*

> *This package allows you to install Calagopus Panel quickly and simply on a YunoHost server.
If you don't have YunoHost, please consult [the guide](https://yunohost.org/install) to learn how to install it.*

## Overview

**Calagopus Panel** is a modern, open-source game server management panel built in Rust (axum + tokio) with a React/Vite frontend. It lets you deploy, monitor, and manage game servers (Minecraft, Rust, and more) through a web interface, similar in role to Pterodactyl.

This YunoHost package installs the **Panel component only** (the web interface and API). To actually host game servers, you will also need at least one **Wings** node connected to the panel. Wings is a separate component and is **not** included in this package.

> **All-In-One variant:** A future `calagopus-panel-aio` package may bundle a local Wings instance for single-box setups. For now, install Wings separately on any server (same or different) following the [Wings documentation](https://calagopus.com/docs/wings/).

**Shipped version:** 1.0~ynh1

**Upstream:** https://github.com/calagopus/panel | https://calagopus.com

---

## First-run setup (OOBE)

After installation, **you must complete setup in your browser**:

1. Open `https://your-domain.tld/` (or the path you chose during install)
2. The **Out-Of-Box Experience** wizard will appear — follow the on-screen instructions to:
   - Create your first administrator account
   - (Optionally) configure initial settings

This cannot be scripted from the install script. **Zero browser interaction is required before the install script finishes, but at least one browser step is required before the panel is usable.**

---

## No YunoHost SSO / No account linking

**YunoHost accounts are intentionally NOT linked to Calagopus accounts.**

This is an explicit design choice. Calagopus manages its own user database, permissions, and authentication entirely independently of YunoHost's LDAP/SSO system. You will create and manage Calagopus users through the Calagopus web interface, not through YunoHost's user management.

The YunoHost permission tile simply controls who can *reach* the URL (via SSOwat reverse-proxy gating). By default it is set to `visitors` (public access), which is required for the OOBE wizard to work.

---

## Important: Encryption Key

During install, this package generates an `APP_ENCRYPTION_KEY` and stores it in:
- `/var/www/calagopus-panel/.env`
- YunoHost settings (`yunohost app setting calagopus-panel encryption_key`)

**This key encrypts all stored credentials in the database (Wings tokens, etc.). If this key is lost or changed, all encrypted data becomes permanently unreadable and existing users will be locked out of their Wings nodes.**

The YunoHost backup system (`yunohost app backup`) includes this file. **Always back up before upgrading or migrating.**

---

## Configuration

Post-install settings can be changed via the YunoHost config panel:

```bash
yunohost app config set calagopus-panel
```

Configurable options:
| Setting | Description |
|---|---|
| `app_debug` | Enable verbose error output (production: keep `false`) |
| `server_name` | Instance label shown in panel footer |
| `sentry_url` | Optional Sentry DSN for error tracking |

---

## Architecture / Technical Details

| Component | Detail |
|---|---|
| **Backend** | Rust (axum, sqlx, tokio, rustis) |
| **Frontend** | React + Vite + TypeScript + Tailwind |
| **Database** | PostgreSQL (provisioned by YunoHost) |
| **Cache** | Redis (YunoHost's built-in instance, separate DB index per multi-instance) |
| **Installation** | Native APT binary from `https://packages.calagopus.com/deb` |
| **Service** | systemd unit managed by YunoHost, runs as `$app` system user |
| **Network** | Listens on `127.0.0.1:$PORT` — NGINX reverse proxy with WebSocket support |

---

## Known Assumptions & Unverified Items

The following items could not be definitively verified at packaging time and are assumptions:

1. **Binary path:** The APT package is assumed to install the binary at `/usr/local/bin/calagopus-panel`. Verify with `dpkg -L calagopus-panel | grep bin` after installation.

2. **Supported architectures:** Only `amd64` is declared. ARM64 and other architectures may or may not be available in the upstream APT repo. Check `https://packages.calagopus.com/` to verify.

3. **Minimum PostgreSQL version:** Upstream docs demonstrate installation with PostgreSQL 18 (PGDG), but this may be "latest available" rather than a hard minimum. This package uses YunoHost's system PostgreSQL. If Calagopus requires PG >= 15 or newer and the Debian system version is too old, install will fail. Check `calagopus-panel --version` output and upstream release notes.

4. **Sub-path support:** The React/Vite SPA may or may not support being served from a URL sub-path (e.g., `/panel`). Many Vite apps hardcode `base: '/'`. If the UI is blank or assets 404 when installed at a non-root path, restrict the `[install.path]` to `"/"` in `manifest.toml`.

5. **APT repository URL and GPG key:** The repo `https://packages.calagopus.com/deb stable main` and key URL `https://packages.calagopus.com/gpg.key` are based on the upstream documentation. Verify these are correct before deploying to production.

6. **License:** Stated as MIT per the prompt spec. Verify against the actual `LICENSE` file in the upstream repository before publishing.

---

## Documentation and links

- Official documentation: https://calagopus.com/docs/panel/
- Upstream source code: https://github.com/calagopus/panel
- YunoHost documentation: https://yunohost.org/packaging_apps
- Discord: https://discord.gg/uSM8tvTxBV

---

## License

This YunoHost package is published under the [AGPL-3.0](https://www.gnu.org/licenses/agpl-3.0) license.

Calagopus Panel itself is published under the MIT license (verify at upstream repo).
