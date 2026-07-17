#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# The binary installed by the calagopus-panel package.
# ASSUMPTION: The APT package places the binary at /usr/local/bin/calagopus-panel.
# If this changes upstream, update the path here and in conf/systemd.service.
panel_binary="/usr/local/bin/calagopus-panel"

# Environment file path — placed in install_dir so multi-instance installs each
# have their own .env and the encryption key is isolated per instance.
# The panel reads .env from the working directory by default; we set WorkingDirectory
# in the systemd unit to $install_dir so it picks up the file automatically.
env_file="__INSTALL_DIR__/.env"

# Log directory
log_dir="/var/log/__APP__"
