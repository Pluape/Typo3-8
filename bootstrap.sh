#!/usr/bin/env bash


#
# Web-Server Installation
#

# Variables
PASSWORD='12345678'
PROJECTFOLDER='typo3'
NEWESTVERSION='8.7.1'

# create project folder
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

# update and upgrade
Update () {
    echo "-- Update packages --"
    sudo apt-get update
    sudo apt-get upgrade
}
Update

# install mysql and give password to installer
echo "-- Prepare configuration for MySQL --"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"

echo "-- Install tools and helpers --"
sudo apt-get install -y --force-yes curl git npm

# install node.js
echo "-- Install NodeJS --"
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -

echo "-- Install packages --"
sudo apt-get install -y --force-yes apache2 mysql-server-5.6 git-core nodejs
Update



# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECTFOLDER}"
    <Directory "/var/www/html/${PROJECTFOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/default.conf


# restart apache
service apache2 restart

# Prepare
sudo add-apt-repository ppa:ondrej/php
Update

sudo apt-get install python-software-properties
Update

sudo apt-get install php





# configure php & apache
echo "-- Configure PHP &Apache --"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/apache2/php.ini
sudo a2enmod rewrite


# install Composer
#curl -s https://getcomposer.org/installer | php
#mv composer.phar /usr/local/bin/composer
#sudo chmod +x /usr/local/bin/composer


# install phpmyadmin
# same password for mysql and phpmyadmin
echo "-- Install phpmyadmin --"
#sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
#sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
#sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
#sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
#sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
#sudo apt-get -y install phpmyadmin

# install sendmail
echo "-- Install Sendmail --"
#sudo apt-get -y install sendmail


#
# TYPO3 Installation
#

# install imagemagick
echo "-- install imahemagick --"
#sudo apt-get update
#sudo apt-get -y install imagemagick
#sudo apt-get -y install php-imagick

# Create Database
echo "-- Setup databases --"
#mysql -u root -p12345678 -e "CREATE DATABASE typo3_${PROJECTFOLDER} CHARACTER SET utf8 COLLATE utf8_general_ci"

# Get TYPO3 Files
echo "-- Setup TYPO3 --"
#cd /var/www/html/
#wget get.typo3.org/8.7
#tar -xzvf 8.7
#mv -v /var/www/html/typo3_src-${NEWESTVERSION}/* /var/www/html/${PROJECTFOLDER}
#sudo rm -r -f /var/www/html/typo3_src-${NEWESTVERSION}/
#sudo rm -r -f /var/www/html/8.7
#cd /var/www/html/${PROJECTFOLDER}
#sudo touch FIRST_INSTALL
#sudo mkdir "/var/www/html/${PROJECTFOLDER}/typo3_src"

# PHP Configuration
#sudo replace "max_execution_time = 30" "max_execution_time = 240" -- /etc/php/apache2/php.ini
#sudo replace "; max_input_vars = 1000" "max_input_vars = 1500" -- /etc/php/apache2/php.ini

# Sendmail Hots configuration
#sudo replace "127.0.0.1 localhost" "127.0.0.1 vagrant-ubuntu-trusty-64.localdomain vagrant-ubuntu-trusty-64 localdev localhost" -- /etc/hosts

sudo service apache2 restart

# Change InstallToolPW in LocalConfiguration.php to: bacb98acf97e0b6112b1d1b650b84971
# Login in TYPO3 backend with: joh316