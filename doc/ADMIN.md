## Administration

Calagopus Panel is administered through its own built-in web interface, accessible at the URL shown in your YunoHost portal.

### Key Points

- **Login**: Use the admin account created during the OOBE setup wizard (not your YunoHost account)
- **Configuration**: Environment variables are stored in `/etc/calagopus/.env` (permissions: `600`, owned by the app user)
- **Logs**: Application logs are at `/var/log/calagopus/calagopus.log`
- **Service**: The panel runs as a systemd service named `calagopus`. Use `sudo systemctl status calagopus` to check its status
- **Database**: PostgreSQL database named `calagopus`, user `calagopus`. Connect with `sudo -u postgres psql calagopus`

### Changing Configuration
To modify environment variables, edit `/etc/calagopus/.env` as root, then restart the service:
```bash
sudo nano /etc/calagopus/.env
sudo systemctl restart calagopus
```

> **Warning**: Never change `APP_ENCRYPTION_KEY` after installation — it will corrupt encrypted data in the database.

### Connecting Wings Nodes
To manage game servers, install Wings on one or more servers and add them as nodes through the Calagopus Panel admin interface under **Admin → Nodes**.

For full administration documentation, see the [official Calagopus docs](https://docs.calagopus.com).
