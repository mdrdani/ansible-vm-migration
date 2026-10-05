#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$DIR"

echo "=========================================================="
echo "    Ansible Discovery & Audit Tool - Server 192.168.1.2    "
echo "=========================================================="

# 1. Periksa Ansible
if ! command -v ansible-playbook >/dev/null 2>&1; then
    echo "❌ [Error] 'ansible' belum terinstall di komputer Anda."
    echo "   Untuk macOS: brew install ansible"
    echo "   Untuk Ubuntu/Debian: sudo apt update && sudo apt install -y ansible"
    exit 1
fi

# 2. Periksa sshpass (dibutuhkan untuk autentikasi SSH password)
if ! command -v sshpass >/dev/null 2>&1; then
    echo "⚠️  [Peringatan] 'sshpass' belum terpasang."
    echo "   Karena autentikasi menggunakan password ('user'), sshpass diperlukan."
    echo "   - macOS: brew install hudochenkov/sshpass/sshpass"
    echo "   - Ubuntu/Debian: sudo apt install -y sshpass"
    echo ""
    read -p "Apakah Anda ingin melanjutkan pengujian koneksi sekarang? (y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        exit 1
    fi
fi

# 3. Uji Ping Ansible
echo -e "\n🔍 Menguji koneksi Ansible ke 192.168.1.2..."
ansible old_servers -m ping || {
    echo -e "\n❌ Gagal terhubung ke 192.168.1.2!"
    echo "   Pastikan:"
    echo "   1. Komputer Anda berada di jaringan LAN / WiFi yang sama dengan 192.168.1.2"
    echo "   2. SSH service di server lama sedang berjalan"
    echo "   3. Password user adalah 'user'"
    exit 1
}

# 4. Jalankan Discovery Playbook
echo -e "\n🚀 Menjalankan Audit & Analisis Server Lama..."
ansible-playbook playbooks/discover_old_server.yml

echo -e "\n✅ Selesai!"
echo "📄 Laporan Markdown: reports/server_analysis_report.md"
echo "📊 Ringkasan JSON:  reports/server_facts.json"
echo ""
echo "Kirimkan isi file reports/server_analysis_report.md ke AI untuk dibuatkan Playbook Deployment ke Server Baru!"
