#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# Calagopus APT repository details
# Source: https://calagopus.com/docs/panel/installation/pkgmanager
# ASSUMPTION: The APT repository key URL and DEB line are inferred from upstream docs.
# Verify against https://packages.calagopus.com/ if these change.
pkg_name="calagopus-panel"
repo_key_url="https://packages.calagopus.com/gpg.key"
repo_key_path="/usr/share/keyrings/calagopus-archive-keyring.gpg"
# Upstream APT repository line
repo_source_string="deb [signed-by=/usr/share/keyrings/calagopus-archive-keyring.gpg] https://packages.calagopus.com/deb stable main"

# The binary installed by the calagopus-panel package.
# ASSUMPTION: The APT package places the binary at /usr/bin/calagopus-panel.
# Verify by inspecting the installed package on first deployment.
panel_binary="/usr/bin/calagopus-panel"

# Environment file path — placed in install_dir so multi-instance installs each
# have their own .env and the encryption key is isolated per instance.
# The panel reads .env from the working directory by default; we set WorkingDirectory
# in the systemd unit to $install_dir so it picks up the file automatically.
env_file="__INSTALL_DIR__/.env"

# Log directory
log_dir="/var/log/__APP__"
