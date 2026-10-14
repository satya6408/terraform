#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl enable --now nginx
echo "<h1>Nginx Installed Using Terraform!</h1>" > /var/www/html/index.html