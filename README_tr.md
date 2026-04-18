# YunoHost için Calagopus Panel

[![Entegrasyon seviyesi](https://dash.yunohost.org/integration/calagopus.svg)](https://dash.yunohost.org/appci/app/calagopus) ![Çalışma durumu](https://ci-apps.yunohost.org/ci/badges/calagopus.status.svg) ![Bakım durumu](https://ci-apps.yunohost.org/ci/badges/calagopus.maintain.svg)

[![Calagopus Panel'i YunoHost ile kurun](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=calagopus)

*[Read this readme in English.](./README.md)* | *[Lire ce readme en français.](./README_fr.md)*

> *Bu paket, Calagopus Panel'i bir YunoHost sunucusuna hızlı ve basit bir şekilde kurmanızı sağlar. YunoHost'unuz yoksa, nasıl kurulacağını öğrenmek için lütfen [kılavuza](https://doc.yunohost.org/admin/get_started/install_on/) başvurun.*

## Genel Bakış

Calagopus Panel, Rust (arka uç) ve React (ön uç) ile oluşturulmuş, açık kaynaklı, kendi sunucunuzda barındırabileceğiniz bir oyun sunucusu yönetim arayüzüdür. Pterodactyl'den ilham alarak, Wings düğüm (node) aracılarıyla oyun sunucuları oluşturmak, yönetmek ve izlemek için modern bir web kullanıcı arayüzü sağlar.

### Özellikler
- Modern, duyarlı (responsive) React tabanlı arayüz
- Hafif, yüksek performanslı Rust arka ucu (backend)
- PostgreSQL ve Valkey/Redis veri katmanı
- Kapsamlı oyun sunucusu yönetimi (güç işlemleri, konsol, dosyalar)

**Gönderilen sürüm:** 0.1~ynh1

## Sorumluluk reddi beyanları / önemli bilgiler

### İlk Kurulum (OOBE)
Kurulumdan sonra, **Out-of-Box Experience (OOBE)** kurulum sihirbazını tamamlamak için panelin URL'sine gidin. Panelin işlevsel hale gelmesi için ilk yönetici hesabınızı buradan oluşturmanız gerekir.

### Kimlik Doğrulama
Calagopus Panel **kendi yerleşik kimlik doğrulama sistemini** kullanır. YunoHost Tek Oturum Açma (SSO) bilerek devre dışı bırakılmıştır. YunoHost kimlik bilgilerinizle giriş yapamazsınız.

### Oyun Sunucusu Düğümleri (Nodes)
Bu paket **yalnızca kontrol panelini** kurar. Oyun sunucularını barındırmak için, aynı veya farklı sunuculara ayrıca **Wings** (düğüm aracı) kurmalı ve bağlamalısınız. Bkz. [Wings belgeleri](https://docs.calagopus.com/wings).

### Mimari ve Gereksinimler
- **İşlemci**: Sadece `amd64` (x86_64) ve `arm64` (aarch64) mimarileri desteklenmektedir.
- **RAM**: Minimum 512 MB (1 GB önerilir).
- **Disk**: 1 GB boş alan.
- Her YunoHost sunucusu için yalnızca **tek bir kuruluma** izin verilir.

## Belgeler ve kaynaklar
* Resmi uygulama web sitesi: <https://calagopus.com>
* Resmi yönetici belgeleri: <https://docs.calagopus.com/panel>
* Üst akış uygulama kod deposu: <https://github.com/calagopus/panel>
* Bir hata bildirin: <https://github.com/YunoHost-Apps/calagopus_ynh/issues>

## Geliştirici bilgileri

Test dalını denemek için lütfen aşağıdaki şekilde ilerleyin.
``` bash
sudo yunohost app install https://github.com/YunoHost-Apps/calagopus_ynh/tree/testing --debug
veya
sudo yunohost app upgrade calagopus -u https://github.com/YunoHost-Apps/calagopus_ynh/tree/testing --debug
```
