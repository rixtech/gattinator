#!/bin/bash

# Apache/PHP

apt-get update
apt-get install -y apache2 php libapache2-mod-php php-mcrypt php-mysql
usermod -a -G www-data ubuntu
echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
chown -R ubuntu:www-data /var/www

echo Restarting Apache
systemctl restart apache2.service


# MySQL

apt-get install -y debconf-utils

export DEBIAN_FRONTEND="noninteractive"

PW=$(openssl rand -base64 12)

cat<<End_PW>/root/.my.cnf
[client]
user=root
password=$PW
End_PW
chmod 0400 /root/.my.cnf

apt-get install debconf-utils
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PW"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PW"

apt-get install -y mysql-server 

# Add a webservice user and test database
mysql<<EndSQL
USE mysql;
CREATE DATABASE testdb;
CREATE USER webapp IDENTIFIED BY 'webappPW';
GRANT ALL ON testdb.* TO 'webapp'@'%';
FLUSH PRIVILEGES;
USE testdb;
CREATE table test (c CHAR(255));
INSERT INTO test (c) VALUES ("hello world");
EndSQL

