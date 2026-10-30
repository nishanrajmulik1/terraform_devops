#!/bin/bash
sudo dnf install -y httpd
sudo systemctl enable --now httpd
echo "<h1>Welcome to Terraform Lab 2</h1>" | sudo tee /var/www/html/index.html