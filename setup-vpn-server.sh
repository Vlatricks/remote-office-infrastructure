#!/bin/bash
# Подготовка VPN-шлюза: firewall, Easy-RSA, запрос сертификата сервера.
# Запуск: sudo ./setup-vpn-server.sh
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "Permission denied: запустите скрипт от root (sudo)." >&2
    exit 1
fi

VPN_PKI_DIR="${HOME}/vpn-easy-rsa"

apt update
apt install -y firewalld easy-rsa

systemctl enable --now firewalld

firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --zone=public --add-port=1194/tcp --permanent
firewall-cmd --reload

mkdir -p "${VPN_PKI_DIR}"
chmod 700 "${VPN_PKI_DIR}"
cp -r /usr/share/easy-rsa/* "${VPN_PKI_DIR}/"
cd "${VPN_PKI_DIR}"

./easyrsa init-pki
EASYRSA_BATCH=1 ./easyrsa gen-req vpn-server nopass

echo "Success! Передайте запрос на CA командой:"
echo "scp ${VPN_PKI_DIR}/pki/reqs/vpn-server.req yc-user@IP_CA_VM:~/"
