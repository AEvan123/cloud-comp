#!/bin/bash

# ==============================================================================
# Cloud-init pour la db
# Ce script fait les actions suivante :
    # Mise à jours du système
    # Crée la BDD
    # Crée un utilisateur qui a accès a la vm app à la BDD
    # Création d'un firewall avec autorisation SSH et MYSQL
# ==============================================================================

apt-get update -y
apt-get install -y mysql-server

sudo mysql_secure_installation <<EOF
n
y
${ROOT_PASS}
${ROOT_PASS}
y
y
y
y
EOF

mysql -u root -p"${ROOT_PASS}" -e "
    CREATE DATABASE IF NOT EXISTS ${DB_USERNAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
    CREATE USER '${DB_USERNAME}'@'${PRIVATE_IP}' IDENTIFIED WITH mysql_native_password BY '${DB_PASS}';
    GRANT ALL PRIVILEGES ON ${DB_USERNAME}.* TO '${DB_USERNAME}'@'${PRIVATE_IP}';
    FLUSH PRIVILEGES;
"

sed -i 's/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

ufw allow ssh
ufw allow 3306/tcp
ufw enable

sudo systemctl restart mysql