#!/bin/bash
set -e

apt-get update -y
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

echo "<h1> Terraform In One Shot by TWS </h1>" | sudo tee /var/www/html/index.html