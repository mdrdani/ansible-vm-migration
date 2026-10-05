# Ansible VM Migration & Discovery Project

Proyek Ansible ini dibuat untuk menganalisis konfigurasi aplikasi CBT dan database pada server lama (`192.168.1.2`), kemudian memigrasikannya secara otomatis ke server baru (`192.168.1.3`) tanpa konfigurasi manual.

---

## Arsitektur Migrasi

- **Source VM (Server Lama)**: `192.168.1.2` (Ubuntu 18.04, Apache 2.4, PHP 7.2, MariaDB 10.1, Candy CBT v2.9.2, DB: `xcandyr4`)
- **Target VM (Server Baru)**: `192.168.1.3` (Ubuntu 22.04 LTS, Apache 2.4, PHP 7.2 via PPA Ondrej, MariaDB 10.6)
- **Controller**: WSL / Linux Machine

---

## Struktur File

```text
ansible-vm-migration/
├── ansible.cfg                           # Konfigurasi Ansible (host key checking disabled, yaml output)
├── inventory.ini                         # Konfigurasi host old_servers & new_servers
├── run.sh                                # Script audit & discovery (Fase 1)
├── migrate.sh                            # Script migrasi otomatis (Fase 2)
├── playbooks/
│   ├── discover_old_server.yml           # Playbook audit & discovery non-intrusif
│   └── migrate_to_new_server.yml         # Playbook migrasi database & web apps
├── templates/
│   └── server_analysis_report.md.j2      # Template laporan hasil audit
└── reports/                              # Output laporan & data backup
    ├── server_analysis_report.md
    ├── server_facts.json
    └── migration_data/
        ├── xcandyr4_backup.sql
        ├── cbt_backup.tar.gz
        └── ioncube_loader_lin_7.2.so
```

---

## Cara Menjalankan

### Fase 1: Discovery & Audit Server Lama
Untuk menjalankan audit awal pada server lama:
```bash
./run.sh
```

### Fase 2: Eksekusi Migrasi Otomatis ke Server Baru
Untuk memigrasikan database `xcandyr4` dan aplikasi `/var/www/html/cbt` ke server `192.168.1.3`:
```bash
./migrate.sh
```
Atau langsung melalui Ansible Playbook:
```bash
ansible-playbook -i inventory.ini playbooks/migrate_to_new_server.yml
```

---

## Apa yang Dilakukan oleh Playbook Migrasi (Fase 2)?
1. **Ekspor Server Lama (`192.168.1.2`)**:
   - Dump database `xcandyr4` menggunakan `mysqldump`
   - Mengompresi folder `/var/www/html/cbt` dan `.htaccess`
   - Mengambil binary `ioncube_loader_lin_7.2.so`
2. **Provisioning Server Baru (`192.168.1.3`)**:
   - Update apt cache & pasang paket dependensi dasar
   - Tambahkan repository `ppa:ondrej/php` (untuk runtime PHP 7.2 di Ubuntu 22.04)
   - Install Apache2, modul PHP 7.2 (`mysqli`, `gd`, `curl`, `zip`, `mbstring`, dll.), dan MariaDB Server
   - Konfigurasi tuning `php.ini` (upload limit 128MB, memory limit 256MB)
   - Konfigurasi `sql_mode = "NO_ENGINE_SUBSTITUTION"` pada MariaDB
   - Konfigurasi modul Apache `rewrite`, `headers`, dan VirtualHost
3. **Restore & Aktivasi**:
   - Buat database `xcandyr4` dan user `phpmyadmin` di MariaDB
   - Restore database `xcandyr4`
   - Ekstrak source code aplikasi ke `/var/www/html/`
   - Set ownership `www-data:www-data` dan hak akses upload
   - Uji respon HTTP aplikasi di `http://192.168.1.3/cbt/`
