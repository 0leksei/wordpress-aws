#! /bin/bash
sudo apt-get update -y
sudo apt-get install apache2 php7.2-mysql php7.2 libapache2-mod-php7.2 php7.2-gd php7.2-ssh2 -y
sudo systemctl enable apache2
sudo systemctl start apache2