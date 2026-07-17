# The Master YunoHost App Packaging & Development Tutorial

> **Audience:** This document is the single source of truth for an autonomous AI agent
> tasked with building, packaging, and maintaining production-grade
> [YunoHost](https://yunohost.org/) applications from scratch. It is derived from a
> forensic study of six official YunoHost apps — `my_webapp_ynh`, `nextcloud_ynh`,
> `roundcube_ynh`, `rustdesk-server_ynh`, `searxng_ynh`, `wireguard_ynh` — and from
> the current YunoHost packaging standards (`packaging_format = 2`,
> `helpers_version = "2.1"`).
>
> **Authoring rules:** Be exhaustive, literal, and explicit. When in doubt, copy a
> pattern verified in one of the reference apps. The agent must be able to ship a
> working YNH package on the first try by following this document.

---

## Table of Contents

1. [Introduction to YunoHost Packaging](#1-introduction-to-yunohost-packaging)
2. [Anatomy of a YunoHost Application](#2-anatomy-of-a-yunohost-application)
3. [`manifest.toml` Deep Dive](#3-manifesttoml-deep-dive)
4. [The Core Packaging Scripts (Line-by-Line)](#4-the-core-packaging-scripts-line-by-line)
   - 4.1 [`install`](#41-install--the-only-mutator-that-acts-on-fresh-state)
   - 4.2 [`remove`](#42-remove--the-only-script-that-must-be-idempotent-downwards)
   - 4.3 [`upgrade`](#43-upgrade--the-most-fragile-script)
   - 4.4 [`backup`](#44- backup--declarative-only)
   - 4.5 [`restore`](#45-restore--rebuild-a-broken-server-from-an-archive)
   - 4.6 [`change_url`](#46-change_url--moving-the-app-on-the-web)
   - 4.7 [`_common.sh`](#47-_commonsh--shared-helpers-and-defaults)
   - 4.8 [`config` + `config_panel.toml`](#48-config--config_panel)
5. [Helper Functions Catalog (`/usr/share/yunohost/helpers`)](#5-helper-functions-catalog)
6. [Architecture & Configuration Patterns](#6-architecture--configuration-patterns)
   - 6.1 [Web apps vs. non-web apps](#61-web-apps-vs-non-web-apps)
   - 6.2 [NGINX template variables](#62-nginx-template-variables)
   - 6.3 [systemd service templates](#63-systemd-service-templates)
   - 6.4 [Permissions & ownership](#64-permissions--ownership)
   - 6.5 [Multi-instance safety](#65-multi-instance-safety)
7. [Database & Dependency Management](#7-database--dependency-management)
8. [Backup & Restore Mechanics (zero data loss)](#8-backup--restore-mechanics)
9. [Maintenance, Logs, Cron, Fail2Ban, Logrotate](#9-maintenance-logs-cron-fail2ban-logrotate)
10. [Tests, Hooks, Config Panel, Docs](#10-tests-hooks-config-panel-docs)
11. [Best Practices / Rules of Engagement for an AI Agent](#11-best-practices--rules-of-engagement)

---

## 1. Introduction to YunoHost Packaging

A YunoHost **app package** is a directory tree of declarative and imperative files
that, when validated by `yunohost tools postinstall` / `yunohost app install`,
turns an arbitrary upstream piece of software into a first-class citizen of a
self-hosted YunoHost server.

Conceptually, a package is a *contract* between:

| Actor | Responsibility |
|---|---|
| **Upstream author** | Ships a tarball, binary, repo, or language-specific artefact. |
| **YunoHost packager (you)** | Writes the manifest, scripts, and conf/ that integrate it. |
| **YunoHost core (Moulinette/Core)** | Provides the helpers, settings DB, SSO, NGINX, systemd, firewall, and rollback safety. |
| **End-user admin** | Runs `yunohost app install <id>` in the webadmin or CLI. |

YunoHost does **not** containerize. Apps run on the host system as a dedicated
system user, with dedicated state directories, and are exposed either through
NGINX (HTTP/HTTPS) or directly through firewall-mapped ports.

**Key invariants every package must respect:**

1. The package must be **idempotent on upgrade** — running upgrade twice in a
   row must yield the same end-state.
2. The package must be **cleanly removable** — `yunohost app remove <id>` must
   leave no orphan config, no orphan systemd unit, no orphan DB user, no orphan
   port.
3. The package must be **restorable from a tar.gz** — `yunohost app restore
   <archive>` on a fresh server must produce a fully working app.
4. The package must be **multi-instance safe** (unless `multi_instance = false`)
   — installing the same app twice (`myapp` and `myapp__2`) must work.

The current packaging format is `packaging_format = 2`, which is TOML-based,
resource-aware, and uses the YunoHost v2 helpers (`helpers_version = "2.1"`).
All six reference apps in this study use it.

---

## 2. Anatomy of a YunoHost Application

### 2.1 Canonical directory tree

```
my_app_ynh/
├── manifest.toml            # MANDATORY — declarative contract
├── README.md                # Recommended
├── LICENSE                  # Mandatory upstream license file
├── tests.toml               # Recommended — CI test plan
├── config_panel.toml        # Optional — post-install runtime config UI
├── check_process            # Legacy helper for packaging v1, omit in v2
├── scripts/
│   ├── _common.sh           # Shared vars/helpers loaded by all scripts
│   ├── install              # MANDATORY
│   ├── remove               # MANDATORY
│   ├── upgrade              # MANDATORY