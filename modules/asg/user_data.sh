#!/bin/bash
sudo apt -y update
sudo apt install  -y apache2
my_private_ip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
my_public_ip=`curl api.ipify.org`
sudo chmod 777 /var/www/html/index.html
echo "<h2>WebServer with private IP: $my_private_ip</h2><br><h2>and public IP: $my_public_ip</h2><br>Build by Terraform!" > /var/www/html/index.html
sudo chmod 755 /var/www/html/index.html
sudo systemctl restart apache2
