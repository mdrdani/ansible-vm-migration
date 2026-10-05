#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$DIR"

# Bypass warning WSL world-writable directory
export ANSIBLE_CONFIG="$DIR/ansible.cfg"

echo "=========================================================="
echo "    Ansible Migration Tool (Fase 2)                       "
echo "    Source: 192.168.1.2 -> Target: 192.168.1.3            "
echo "=========================================================="

# 1. Periksa Ansible & sshpass
if ! command -v ansible-playbook >/dev/null 2>&1; then
    echo "❌ [Error] 'ansible' belum terinstall di komputer Anda."
    exit 1
fi

if ! command -v sshpass >/dev/null 2>&1; then
    echo "❌ [Error] 'sshpass' belum terpasang."
    exit 1
fi

# 2. Uji Koneksi ke Kedua Server
echo -e "\n🔍 Menguji koneksi Ansible ke Server Lama (192.168.1.2)..."
ansible old_servers -i "$DIR/inventory.ini" -m ping || {
    echo -e "\n❌ Gagal terhubung ke Server Lama 192.168.1.2!"
    exit 1
}

echo -e "\n🔍 Menguji koneksi Ansible ke Server Baru (192.168.1.3)..."
ansible new_servers -i "$DIR/inventory.ini" -m ping || {
    echo -e "\n❌ Gagal terhubung ke Server Baru 192.168.1.3!"
    exit 1
}

# 3. Konfirmasi Eksekusi
echo -e "\n⚠️  PERINGATAN MIGRASI:"
echo "   - Playbook ini akan men-dump database xcandyr4 dari 192.168.1.2"
echo "   - Mengunduh dan mentransfer folder /var/www/html/cbt"
echo "   - Menginstall Apache2, PHP 7.2, MariaDB di 192.168.1.3"
echo "   - Me-restore database xcandyr4 dan file CBT ke 192.168.1.3"
echo ""
read -p "Apakah Anda siap memulai proses migrasi sekarang? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Migrasi dibatalkan."
    exit 0
fi

# 4. Jalankan Migration Playbook
echo -e "\n🚀 Menjalankan Playbook Migrasi ke Server Baru..."
ansible-playbook -i "$DIR/inventory.ini" "$DIR/playbooks/migrate_to_new_server.yml"

echo -e "\n✅ Migrasi Selesai!"
echo "Silakan buka browser Anda dan akses aplikasi di server baru:"
echo "👉 http://192.168.1.3/cbt/"
