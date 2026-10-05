# Hasil Analisis & Audit Server Lama (Migrasi VM)

- **Tanggal Analisis**: 2026-10-05T02:10:26Z
- **Target Hostname**: `servercbt`
- **IP Address**: `192.168.1.2`
- **OS Distribution**: `Ubuntu 18.04` (Kernel: `4.15.0-213-generic`)
- **Arsitektur**: `x86_64`
- **Spesifikasi**: 1 vCPU | 2953 MB RAM

---

## 1. Network & Listening Ports
Port-port aktif yang sedang mendengarkan koneksi:

```text
Netid  State    Recv-Q   Send-Q      Local Address:Port     Peer Address:Port                                                                                   
udp    UNCONN   0        0           127.0.0.53%lo:53            0.0.0.0:*       users:(("systemd-resolve",pid=737,fd=12))                                      
tcp    LISTEN   0        80              127.0.0.1:3306          0.0.0.0:*       users:(("mysqld",pid=1029,fd=70))                                              
tcp    LISTEN   0        128         127.0.0.53%lo:53            0.0.0.0:*       users:(("systemd-resolve",pid=737,fd=13))                                      
tcp    LISTEN   0        128               0.0.0.0:22            0.0.0.0:*       users:(("sshd",pid=897,fd=3))                                                  
tcp    LISTEN   0        128                     *:80                  *:*       users:(("apache2",pid=2112,fd=4),("apache2",pid=2102,fd=4),("apache2",pid=2101,fd=4),("apache2",pid=2100,fd=4),("apache2",pid=2099,fd=4),("apache2",pid=2098,fd=4),("apache2",pid=2097,fd=4),("apache2",pid=1195,fd=4),("apache2",pid=1194,fd=4),("apache2",pid=1193,fd=4),("apache2",pid=1103,fd=4))
tcp    LISTEN   0        128                  [::]:22               [::]:*       users:(("sshd",pid=897,fd=4))                                                  
```

---

## 2. Active Systemd Services
Daftar service yang sedang running:

```text
- accounts-daemon.service
- apache2.service
- atd.service
- cron.service
- dbus.service
- getty@tty1.service
- lfd.service
- lvm2-lvmetad.service
- lxcfs.service
- mariadb.service
- networkd-dispatcher.service
- php7.2-fpm.service
- polkit.service
- rsyslog.service
- ssh.service
- systemd-journald.service
- systemd-logind.service
- systemd-networkd.service
- systemd-resolved.service
- systemd-timesyncd.service
- systemd-udevd.service
- unattended-upgrades.service
- user@1000.service
```

---

## 3. Web Server & Virtual Hosts
```text
=== NGINX ===
Nginx not installed
-e 
=== APACHE ===
Server version: Apache/2.4.29 (Ubuntu)
Server built:   2023-03-08T17:34:33
total 8
drwxr-xr-x 2 root root 4096 Jun 22  2021 .
drwxr-xr-x 8 root root 4096 Mar 17  2023 ..
lrwxrwxrwx 1 root root   35 Jun 22  2021 000-default.conf -> ../sites-available/000-default.conf
```

---

## 4. Database & Caching Services
```text
=== MYSQL / MARIADB ===
Status: Active
mysql  Ver 15.1 Distrib 10.1.48-MariaDB, for debian-linux-gnu (x86_64) using readline 5.2
-e 
=== POSTGRESQL ===
PostgreSQL is not active or not installed
-e 
=== REDIS ===
Redis is not active or not installed
-e 
=== MONGODB ===
MongoDB is not active or not installed
```

---

## 5. Runtimes & Containerization (Docker, Node, PHP, Python)
```text
=== DOCKER ===
Docker not installed
-e 
=== NODE.JS & PM2 ===
Node.js not installed
-e 
=== PHP ===
PHP 7.2.24-0ubuntu0.18.04.17 (cli) (built: Feb 23 2023 13:29:25) ( NTS )
PHP Modules: [PHP Modules] bz2 calendar Core ctype curl date dom exif fileinfo filter ftp gd gettext hash iconv ionCube Loader json libxml mbstring mysqli mysqlnd openssl pcntl pcre PDO pdo_mysql Phar posix readline Reflection session shmop SimpleXML sockets sodium SPL standard sysvmsg sysvsem sysvshm tokenizer wddx xml xmlreader xmlwriter xsl Zend OPcache zip zlib  [Zend Modules] Zend OPcache the ionCube PHP Loader + ionCube24  
-e 
=== PYTHON ===
Python 3.6.9
```

---

## 6. Lokasi File Aplikasi & Konfigurasi (.env)
```text
=== DIRECTORY /var/www ===
total 12
drwxr-xr-x  3 root root 4096 Jun 22  2021 .
drwxr-xr-x 14 root root 4096 Jun 22  2021 ..
drwxr-xr-x  3 root root 4096 Jun 23  2021 html
-e 
=== DIRECTORY /opt ===
total 8
drwxr-xr-x  2 root root 4096 Aug  7  2020 .
drwxr-xr-x 24 root root 4096 Jun 30  2023 ..
-e 
=== DIRECTORY /home/user ===
total 52
drwxr-xr-x 7 user user 4096 Oct  5 09:08 .
drwxr-xr-x 3 root root 4096 Jun 22  2021 ..
drwx------ 3 user user 4096 Oct  5 09:08 .ansible
-rw------- 1 user user 3130 Oct  5 09:00 .bash_history
-rw-r--r-- 1 user user  220 Apr  5  2018 .bash_logout
-rw-r--r-- 1 user user 3771 Apr  5  2018 .bashrc
drwx------ 2 user user 4096 Jun 22  2021 .cache
drwx------ 3 user user 4096 Jun 22  2021 .gnupg
drwxrwxr-x 3 user user 4096 Jun 22  2021 .local
-rw------- 1 user user   67 Oct 30  2021 .mysql_history
-rw-r--r-- 1 user user  807 Apr  5  2018 .profile
-rw-r--r-- 1 user user    0 Jun 22  2021 .sudo_as_admin_successful
drwxrwxr-x 5 user user 4096 Jun 23  2021 .vscode-server
-rw-rw-r-- 1 user user  183 Jun 23  2021 .wget-hsts
-e 
=== DETEKSI FILE ENV / CONFIG ===
```

---

## 7. Scheduled Tasks (Cron)
```text
=== CRONTAB USER: user ===
No crontab for user
-e 
=== CRONTAB USER: root ===
No crontab for root
-e 
=== /etc/cron.d/ ===
total 36
drwxr-xr-x   2 root root 4096 Aug  1  2023 .
drwxr-xr-x 102 root root 4096 Jul  4  2023 ..
-rw-r--r--   1 root root   14 Feb  1  2013 csf-cron
-rw-------   1 root root   47 Jun 22  2021 csf_update
-rw-r--r--   1 root root   74 Aug  1  2023 lfd-cron
-rw-r--r--   1 root root  589 Jan 15  2020 mdadm
-rw-r--r--   1 root root  712 Jan 18  2018 php
-rw-r--r--   1 root root  102 Nov 16  2017 .placeholder
-rw-r--r--   1 root root  191 Aug  7  2020 popularity-contest
```

---

## Rekomendasi Langkah Selanjutnya (Fase 2 - Migrasi)
1. Periksa bagian **Database** dan tentukan apakah perlu dump otomatis (misal `mysqldump` / `pg_dump`).
2. Periksa bagian **Lokasi File Aplikasi** dan **Web Server Sites-Enabled** untuk menentukan folder sumber yang akan di-sync (menggunakan `ansible.posix.synchronize` / `rsync`).
3. Kirimkan file ini kembali ke asisten AI untuk langsung dibuatkan **Ansible Deployment Playbook** untuk server baru Anda!
