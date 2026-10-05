# Ansible VM Migration & Discovery Project

Proyek Ansible ini dibuat untuk menganalisis dan mengaudit seluruh konfigurasi aplikasi, service, runtime, dan database pada server lama (`192.168.1.2`) sebelum dipindahkan secara otomatis ke server baru tanpa konfigurasi manual ulang.

---

## Struktur File

```text
ansible-vm-migration/
├── ansible.cfg                          # Konfigurasi Ansible (host key checking disabled, yaml output)
├── inventory.ini                        # Target server lama (192.168.1.2) & template server baru
├── run.sh                               # Script otomatis (cek dependensi, ping test, & eksekusi)
├── playbooks/
│   └── discover_old_server.yml          # Playbook audit & discovery non-intrusif
├── templates/
│   └── server_analysis_report.md.j2     # Template laporan hasil audit
└── reports/                             # Hasil audit akan otomatis tersimpan di sini
    ├── server_analysis_report.md
    └── server_facts.json
```

---

## Persyaratan Awal di Laptop / Komputer Anda

Karena server `192.168.1.2` berada di jaringan lokal (LAN) Anda:

1. **Ansible**:
   - macOS: `brew install ansible`
   - Linux: `sudo apt update && sudo apt install -y ansible`

2. **sshpass** (dibutuhkan karena autentikasi SSH menggunakan password):
   - macOS: `brew install hudochenkov/sshpass/sshpass`
   - Linux: `sudo apt install -y sshpass`

---

## Cara Menjalankan

Masuk ke direktori proyek ini lalu jalankan script bantuan:

```bash
cd /Users/mdrdani/.gemini/antigravity-ide/scratch/ansible-vm-migration
./run.sh
```

Atau jika ingin menjalankan playbook langsung via Ansible:

```bash
ansible-playbook playbooks/discover_old_server.yml
```

---

## Hasil Analisis (Fase 1)

Setelah playbook selesai dijalankan, dua file laporan akan terbentuk otomatis:
- [server_analysis_report.md](file:///Users/mdrdani/.gemini/antigravity-ide/scratch/ansible-vm-migration/reports/server_analysis_report.md)
- [server_facts.json](file:///Users/mdrdani/.gemini/antigravity-ide/scratch/ansible-vm-migration/reports/server_facts.json)

Laporan ini memuat:
- Spesifikasi hardware & OS
- Port dan service yang sedang berjalan
- Konfigurasi Web Server (Nginx / Apache) & Virtual Host
- Status Database (MySQL, PostgreSQL, Redis, MongoDB)
- Runtime aktif (Docker containers, Node.js, PM2, Python, PHP)
- Lokasi folder aplikasi (`/var/www`, `/opt`, `/home/user`) dan file `.env`
- Jadwal Cron job

---

## Langkah Selanjutnya (Fase 2 - Migrasi ke Server Baru)

Setelah laporan di atas terbentuk:
1. Bagikan isi file `server_analysis_report.md` di chat ini.
2. Berikan IP & akses SSH server baru Anda.
3. Kami akan langsung mengenerate **Ansible Deployment & Data Migration Playbook** yang siap dijalankan untuk mereplikasi server lama ke server baru secara otomatis.
