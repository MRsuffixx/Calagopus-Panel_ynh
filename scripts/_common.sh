#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
# Sourced by every script in this package.
#=================================================

# Database identifiers — derived from the app name for consistency
db_user=$app
db_name=$app

#=================================================
# ARCH DETECTION
#=================================================

# ynh_detect_calagopus_arch
# Returns the architecture string used in Calagopus GitHub release filenames.
# GitHub release binary names:
#   panel-rs-x86_64-linux   (for amd64)
#   panel-rs-aarch64-linux  (for arm64)
# uname -m returns: x86_64 on amd64, aarch64 on arm64
ynh_detect_calagopus_arch() {
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64)
            echo "x86_64"
            ;;
        aarch64)
            echo "aarch64"
            ;;
        *)
            ynh_die "Unsupported CPU architecture: $arch. Calagopus Panel only supports x86_64 and aarch64."
            ;;
    esac
}

#=================================================
# BINARY DOWNLOAD
#=================================================

# ynh_download_calagopus_binary
# Downloads the latest Calagopus Panel binary from GitHub Releases
# and installs it at /usr/local/bin/calagopus-panel.
# Arguments: none (reads arch from uname -m automatically)
ynh_download_calagopus_binary() {
    local arch
    arch=$(ynh_detect_calagopus_arch)

    local binary_url="https://github.com/calagopus/panel/releases/latest/download/panel-rs-${arch}-linux"
    local binary_dest="/usr/local/bin/calagopus-panel"

    ynh_script_progression "Downloading Calagopus Panel binary for ${arch}..."

    curl --fail --silent --location \
        --output "$binary_dest" \
        "$binary_url" \
        || ynh_die "Failed to download Calagopus Panel binary from: $binary_url"

    chmod +x "$binary_dest"

    ynh_script_progression "Binary installed at $binary_dest"
}

#=================================================
# CACHE SERVER (VALKEY / REDIS)
#=================================================

# ynh_install_calagopus_cache
# Attempts to install Valkey (preferred, faster).
# Falls back to redis-server if Valkey is not available in APT.
# Enables and starts the chosen service.
# Sets the global variable $cache_service to the started service name.
ynh_install_calagopus_cache() {
    ynh_script_progression "Installing cache server (Valkey preferred, Redis fallback)..."

    if apt-cache show valkey > /dev/null 2>&1; then
        ynh_script_progression "Installing Valkey..."
        ynh_package_install valkey
        systemctl enable valkey-server --quiet
        systemctl start valkey-server
        ynh_app_setting_set --key=cache_service --value="valkey-server"
        ynh_script_progression "Valkey started successfully."
    else
        ynh_script_progression "Valkey not available — falling back to redis-server..."
        ynh_package_install redis-server
        systemctl enable redis-server --quiet
        systemctl start redis-server
        ynh_app_setting_set --key=cache_service --value="redis-server"
        ynh_script_progression "redis-server started successfully."
    fi
}

#=================================================
# POSTGRESQL HELPERS
#=================================================

# ynh_psql_execute_as_postgres <sql>
# Runs a single SQL command as the postgres superuser.
ynh_psql_execute_as_postgres() {
    sudo --login --user=postgres \
        psql --command="$1" \
        2>&1
}

# ynh_calagopus_setup_db <db_user> <db_name> <db_pwd>
# Creates the PostgreSQL role and database for Calagopus.
# Idempotent: uses IF NOT EXISTS where possible.
ynh_calagopus_setup_db() {
    local _db_user="$1"
    local _db_name="$2"
    local _db_pwd="$3"

    ynh_script_progression "Configuring PostgreSQL database and user..."

    # Create the user (role) only if it doesn't already exist
    if ! sudo --login --user=postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$_db_user'" | grep -q 1; then
        sudo --login --user=postgres psql --command="CREATE USER $_db_user WITH PASSWORD '$_db_pwd';"
    else
        sudo --login --user=postgres psql --command="ALTER USER $_db_user WITH PASSWORD '$_db_pwd';"
    fi

    # Create the database only if it doesn't already exist
    if ! sudo --login --user=postgres psql -lqt | cut -d \| -f 1 | grep -qw "$_db_name"; then
        sudo --login --user=postgres psql --command="CREATE DATABASE $_db_name OWNER $_db_user;"
    else
        sudo --login --user=postgres psql --command="ALTER DATABASE $_db_name OWNER TO $_db_user;"
    fi

    # Grant all privileges regardless
    sudo --login --user=postgres psql --command="GRANT ALL PRIVILEGES ON DATABASE $_db_name TO $_db_user;"

    ynh_script_progression "PostgreSQL database '$_db_name' ready for user '$_db_user'."
}

# ynh_calagopus_drop_db <db_user> <db_name>
# Drops the PostgreSQL database and role created for Calagopus.
ynh_calagopus_drop_db() {
    local _db_user="$1"
    local _db_name="$2"

    ynh_script_progression "Removing PostgreSQL database and user..."

    sudo --login --user=postgres psql --command=\
"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$_db_name';" 2>/dev/null || true

    sudo --login --user=postgres psql --command="DROP DATABASE IF EXISTS $_db_name;" 2>/dev/null || true
    sudo --login --user=postgres psql --command="DROP USER IF EXISTS $_db_user;" 2>/dev/null || true

    ynh_script_progression "PostgreSQL cleanup complete."
}

#=================================================
# LOG DIRECTORY
#=================================================

# ynh_calagopus_setup_log_dir
# Creates /var/log/$app with correct ownership for the panel to write logs.
ynh_calagopus_setup_log_dir() {
    mkdir -p "/var/log/$app"
    chown "$app:$app" "/var/log/$app"
    chmod 750 "/var/log/$app"
}

#=================================================
# CONFIG DIRECTORY
#=================================================

# ynh_calagopus_setup_config_dir
# Creates /etc/calagopus with correct ownership.
ynh_calagopus_setup_config_dir() {
    mkdir -p /etc/calagopus
    chown "$app:$app" /etc/calagopus
    chmod 750 /etc/calagopus
}

# ynh_calagopus_fix_env_perms
# Ensures /etc/calagopus/.env has correct restrictive permissions.
# The file contains secrets (DB password, encryption key).
ynh_calagopus_fix_env_perms() {
    chown "$app:$app" /etc/calagopus/.env
    chmod 600 /etc/calagopus/.env
}
