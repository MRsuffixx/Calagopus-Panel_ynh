## First-run setup required

After installation, open your browser and navigate to your panel URL.

You will see the **Calagopus Out-Of-Box Experience (OOBE)** wizard. Follow the on-screen instructions to create your first administrator account.

> **Note:** YunoHost accounts are **not** linked to Calagopus accounts. This is intentional. Create and manage Calagopus users through the Calagopus interface.

> **Important:** Your `APP_ENCRYPTION_KEY` was generated at install time and stored in `/var/www/__APP__/.env`. Keep it safe — it encrypts all stored credentials. Back up your panel regularly with `yunohost app backup create __APP__`.
