#!/bin/bash
yum update -y
amazon-linux-extras enable postgresql14
yum install -y postgresql postgresql-server

postgresql-setup initdb
systemctl start postgresql
systemctl enable postgresql

sed -i 's/^local\s\+all\s\+all\s\+ident/local   all             all                                     md5/' /var/lib/pgsql/data/pg_hba.conf
sed -i 's/^host\s\+all\s\+all\s\+127.0.0.1\/32\s\+ident/host    all             all             127.0.0.1\/32            md5/' /var/lib/pgsql/data/pg_hba.conf
echo "host    all             all             10.0.0.0/16             md5" >> /var/lib/pgsql/data/pg_hba.conf
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf

systemctl restart postgresql

sudo -u postgres psql <<SQL
ALTER USER postgres WITH PASSWORD 'TechCorp@DB2024!';
CREATE DATABASE techcorp_db;
CREATE USER techcorp_user WITH PASSWORD 'AppDB@2024!';
GRANT ALL PRIVILEGES ON DATABASE techcorp_db TO techcorp_user;
SQL

useradd -m -s /bin/bash dbadmin
echo "dbadmin:TechCorp@2024!" | chpasswd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd