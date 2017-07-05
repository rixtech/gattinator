#!/bin/bash

# Apache/PHP

apt-get update
apt-get install -y apache2 php libapache2-mod-php php-mcrypt php-mysql
usermod -a -G www-data ubuntu
echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
chown -R ubuntu:www-data /var/www

# MySQL

apt-get install -y debconf-utils

