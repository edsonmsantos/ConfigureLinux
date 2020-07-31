echo Preparando......
sudo mkdir /home/downloads
cd /home/downloads
sudo chmod -R 777 /home/downloads

echo Git
sudo apt install git -y

echo Apache
sudo apt-get install apache2 -y

echo PHP
sudo apt install php7.4-cli libapache2-mod-php7.4 php7.4-mysql php7.4-curl php-memcached php7.4-dev php7.4-sqlite3 php7.4-mbstring php7.4-gd php7.4-js -y
sudo apt install php-soap -y

echo Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo Limpando...
sudo apt autoremove
