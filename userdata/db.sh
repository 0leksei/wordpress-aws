#! /bin/bash
sudo apt-get update -y
sudo apt-get install mysql-server python-pip python-mysqldb -y
sudo pip install pymysql
sudo systemctl enable mysql
sudo systemctl start mysql