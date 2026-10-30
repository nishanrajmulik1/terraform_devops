#!/bin/bash
sudo dnf install -y httpd
sudo systemctl enable --now httpd
echo "<h1>Welcome to Dynamic Private Terraform Lab Instance!</h1>" | sudo tee /var/www/html/index.html