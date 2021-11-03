#!/bin/sh

yum install -y httpd git
cd /var/www
git clone https://fhoubart@bitbucket.org/fhoubart/testphaser.git 

rm -rf /var/www/html
ln -s /var/www/testphaser/public_html /var/www/html 
systemctl start httpd
