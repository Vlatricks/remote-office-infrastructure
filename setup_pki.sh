#!/bin/bash
# Развертывание Удостоверяющего Центра (Root CA) на Easy-RSA.
# Запуск: sudo ./setup_pki.sh
set -euo pipefail
 
if [ "$EUID" -ne 0 ]; then
    echo "Permission denied: запустите скрипт от root (sudo)." >&2
    exit 1
fi
 
CA_DIR="${HOME}/easy-rsa"
 
apt update
apt install -y firewalld easy-rsa
 
systemctl enable --now firewalld
 
# CA-серверу нужен только SSH для администрирования.
# Порт 1194 здесь не нужен — он открывается на VPN-шлюзе.
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload
 
mkdir -p "${CA_DIR}"
chmod 700 "${CA_DIR}"
cp -r /usr/share/easy-rsa/* "${CA_DIR}/"
cd "${CA_DIR}"
 
./easyrsa init-pki
EASYRSA_BATCH=1 ./easyrsa build-ca nopass
 
echo "Готово. Корневой сертификат: ${CA_DIR}/pki/ca.crt"
 
