#!/bin/bash
if [ "$EUID" -ne 0 ]; then
	echo "Permission denied"
	exit 1
fi

apt update 
apt install -y firewalld
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --zone=public --add-port=1194/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
systemctl reload firewalld

apt install -y easy-rsa
mkdir ~/easy-rsa
chmod 700 ~/easy-rsa
cp -r /usr/share/easy-rsa/* ~/easy-rsa/
cd ~/easy-rsa 
./easyrsa init-pki
EASYRSA_BATCH=1 ./easyrsa build-ca nopass
