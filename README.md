# Wordpress installation script for Ubuntu
Wordpress installation script for Ubuntu (Tested on Ubuntu 20.04 but should work on other versions also). 

Script made to automate process of Wordpress installation on Ubuntu. Copy and past 3 lines and Wordpress will be up and running

## How it works?

WHen the script is executed it is going to install all necessary dependencies, MySql, Apache and Wordpress itself.

Basic configuration of Apache will be installed on /etc/apache2/sites-available/wordpress.conf and Wordpress config file in /srv/www/wordpress/wp-config.php

At the end of installation summary will be displaying.

## How to use the script?

<b>Step 1 - download the script</b>
```
sudo wget https://raw.githubusercontent.com/cierek/Wordpress/main/wordpress_install.sh
```
<b>Step 2 - modify the script</b>

This is not necesary if you are creating a test wordpress to play on your local machine. However, it is highly recommended to change the default password.

<b>Step 3 - make script executable</b>
```
sudo chmod +x wordpress_install.sh
```
<b>Step 4 - execute the script</b>
```
sudo ./wordpress_install.sh
```
