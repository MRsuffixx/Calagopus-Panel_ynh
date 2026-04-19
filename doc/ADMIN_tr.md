## Yönetim

Calagopus Panel, YunoHost portalınızda gösterilen URL üzerinden erişilebilen, kendisine ait yerleşik bir web arayüzü aracılığıyla yönetilir.

### Önemli Noktalar

- **Giriş**: YunoHost hesabınızı değil, kurulum sihirbazı (OOBE) sırasında oluşturulan yönetici (admin) hesabını kullanın.
- **Yapılandırma**: Ortam değişkenleri `/etc/calagopus/.env` dosyasında saklanır (izinler: `600`, dosya sahibi: uygulama kullanıcısı).
- **Günlükler (Logs)**: Uygulama günlüklerine `/var/log/calagopus/calagopus.log` adresinden ulaşılabilir.
- **Servis**: Panel, `calagopus` adlı bir systemd servisi olarak çalışır. Durumunu kontrol etmek için `sudo systemctl status calagopus` komutunu kullanın.
- **Veritabanı**: `calagopus` adlı PostgreSQL veritabanını ve `calagopus` kullanıcısını kullanır. Bağlanmak için: `sudo -u postgres psql calagopus`

---

### Yapılandırmayı Değiştirme
Ortam değişkenlerini düzenlemek için `/etc/calagopus/.env` dosyasını root yetkisiyle düzenleyin ve ardından servisi yeniden başlatın:

```bash
sudo nano /etc/calagopus/.env
sudo systemctl restart calagopus
```

> **Uyarı**: Kurulumdan sonra `APP_ENCRYPTION_KEY` değerini asla değiştirmeyin; bu, veritabanındaki şifrelenmiş verilerin bozulmasına neden olur.

---

### Wings Düğümlerini (Nodes) Bağlama
Oyun sunucularını yönetmek için bir veya daha fazla sunucuya **Wings** kurun ve bunları Calagopus Panel yönetici arayüzünde **Admin → Nodes** sekmesinden düğüm olarak ekleyin.

Kapsamlı yönetim belgeleri için [resmi Calagopus dokümantasyonuna](https://docs.calagopus.com) göz atın.
