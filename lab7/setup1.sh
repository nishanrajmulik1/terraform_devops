#!/bin/bash
sudo dnf install -y httpd
sudo systemctl enable --now httpd
echo "<h1>Welcome to Dynamic Terraform Lab Public Instance!</h1>" | sudo tee /var/www/html/index.html