#!/bin/bash
################################################################################
# Script for installing Wordpress on Ubuntu 20.04 (other versions could work too)
# Author: Piotr Cierkosz
#-------------------------------------------------------------------------------
# This script will install Wordpress on your Ubuntu 20.04 server. It can install multiple Odoo instances
################################################################################

#-------------------------------------------------
# Dependencies
#--------------------------------------------------
echo -e "\n---- Installing dependencies ----"
sudo apt update
sudo apt install apache2 \
                 ghostscript \
                 libapache2-mod-php \
                 mysql-server \
                 php \
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
                 php-zip
sudo apt install curl

#--------------------------------------------------
# Install Wordpress
#--------------------------------------------------
echo -e "\n---- Install Wordpress ----"
sudo mkdir -p /srv/www
sudo chown www-data: /srv/www
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www

#--------------------------------------------------
# Configure DB
#--------------------------------------------------

sudo mysql -u root -e "CREATE DATABASE wordpress;"
sudo mysql -u root -e "CREATE USER wordpress@localhost IDENTIFIED BY '<your-password>';"
sudo mysql -u root -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost;"
sudo mysql -u root -e "#FLUSH PRIVILEGES;"
sudo mysql -u root -e "quit"

sudo service mysql start
#--------------------------------------------------
# Wordpress DB Connection
#--------------------------------------------------

sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php

sudo -u www-data sed -i 's/database_name_here/wordpress/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/username_here/wordpress/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/password_here/<your-password>/' /srv/www/wordpress/wp-config.php

#--------------------------------------------------
# Apache
#--------------------------------------------------


cat <<EOF > ~/wordpress
<VirtualHost *:80>
  DocumentRoot /srv/www/wordpress
  <Directory /srv/www/wordpress>
      Options FollowSymLinks
      AllowOverride Limit Options FileInfo
      DirectoryIndex index.php
      Require all granted
  </Directory>
  <Directory /srv/www/wordpress/wp-content>
      Options FollowSymLinks
      Require all granted
  </Directory>
</VirtualHost>
EOF

sudo mv ~/wordpress /etc/apache2/sites-available/wordpress.conf

sudo a2ensite wordpress

sudo a2enmod rewrite

sudo a2dissite 000-default

sudo service apache2 reload

sudo systemctl reload apache2

echo "-----------------------------------------------------------"
echo "Your Wordpress server is up and running. Specifications:"
echo "Port: 80"
echo "Config: /srv/www/wordpress/wp-config.php"
echo "Apache config: /etc/apache2/sites-available/wordpress.conf"
echo "Please remember to replace default password and put your unique phrase in wp-config.php"
echo "-----------------------------------------------------------"
