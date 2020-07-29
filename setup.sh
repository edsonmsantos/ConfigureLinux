sudo apt update

# Install Apache + PHP
sudo apt install apache2 -y
sudo apt install php7.4-cli libapache2-mod-php7.4 php7.4-mysql php7.4-curl php-memcached php7.4-dev php7.4-sqlite3 php7.4-mbstring php7.4-gd php7.4-json -y
sudo apt install unzip -y
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer


# Install MySQL
sudo apt install mysql-server
