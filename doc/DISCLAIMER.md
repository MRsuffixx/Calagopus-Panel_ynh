## Important Notes

### First-Time Setup
After installation, navigate to `https://your-domain/` to complete the **Out-of-Box Experience (OOBE)** setup wizard. This is where you create your initial administrator account. **The panel is not functional until OOBE is completed.**

### Authentication
Calagopus Panel uses its **own built-in authentication system**. YunoHost Single Sign-On (SSO) is intentionally disabled — you will not be able to log in with your YunoHost credentials. Create a dedicated Calagopus admin account during OOBE.

### No Multi-Instance Support
Only **one installation** of Calagopus Panel is allowed per YunoHost server (`multi_instance = false`). If you need multiple panels, run separate YunoHost instances.

### Encryption Key Warning
The `APP_ENCRYPTION_KEY` is generated once during installation and stored in YunoHost settings. **Never change it after installation** — doing so will corrupt all encrypted data in the database (including server credentials and tokens). It is preserved automatically across upgrades.

### Valkey vs Redis
The package prefers **Valkey** (faster, more actively maintained) but falls back to **redis-server** if Valkey is not available in your system's APT repositories. Both are functionally identical for Calagopus Panel's use case.

### Reverse Proxy Architecture
The Rust binary listens only on `127.0.0.1:PORT` and is **not directly internet-accessible**. All traffic flows through NGINX, which adds HTTPS termination and the necessary security headers.

### Game Server Management
This package installs **only the control panel**. To actually manage game servers, you must separately install and connect **Wings** (the node agent) on the same or different servers. See the [Wings documentation](https://docs.calagopus.com/wings) for setup instructions.

### Resource Requirements
- **Minimum RAM**: 512 MB (1 GB recommended; panel itself uses ~90 MB, PostgreSQL ~66 MB)
- **Minimum Disk**: 1 GB free space
- **CPU**: x86_64 (amd64) or ARM64 only — no 32-bit support

### PostgreSQL Version
This package installs the default `postgresql` package for your Debian/Ubuntu version. PostgreSQL 14+ is recommended. The installation documentation mentions PostgreSQL 18 but this package uses whatever is available in your system repositories to maximize compatibility.

### Backup Notes
Backups include the `.env` configuration file and a full PostgreSQL dump. The binary itself is **not included** (it is re-downloaded from GitHub on restore). Logs are also excluded to keep archive sizes manageable.
