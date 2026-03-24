#!/bin/bash

# Bootstrap script for Apache2 webserver
# This script installs and configures Apache2 on Ubuntu/Debian systems

set -e  # Exit on any error

echo "======================================"
echo "Apache2 Webserver Bootstrap Script"
echo "======================================"

# Update system packages
echo "Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Apache2
echo "Installing Apache2..."
sudo apt-get install -y apache2

# Enable essential Apache2 modules
echo "Enabling Apache2 modules..."
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enmod headers
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod remoteip

# Create default document root
echo "Setting up document root..."
sudo mkdir -p /var/www/html
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Create a simple health check page
echo "Creating health check page..."
sudo tee /var/www/html/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Apache2 Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .success { color: #28a745; }
    </style>
</head>
<body>
    <h1 class="success">✓ Apache2 is running successfully!</h1>
    <p>Timestamp: $(date)</p>
</body>
</html>
EOF

# Create a health check endpoint
echo "Creating health check endpoint..."
sudo tee /var/www/html/health > /dev/null <<EOF
OK
EOF

# Enable Apache2 service to start on boot
echo "Enabling Apache2 service..."
sudo systemctl enable apache2

# Start Apache2 service
echo "Starting Apache2 service..."
sudo systemctl start apache2

# Verify Apache2 is running
echo ""
echo "======================================"
if sudo systemctl is-active --quiet apache2; then
    echo "✓ Apache2 is running successfully!"
else
    echo "✗ Apache2 failed to start. Check logs with: sudo journalctl -u apache2"
    exit 1
fi

# Display server information
echo "======================================"
echo "Apache2 Version:"
apache2ctl -v | head -1
echo ""
echo "Document Root: /var/www/html"
echo "Configuration: /etc/apache2/apache2.conf"
echo "Log Files: /var/log/apache2/"
echo ""
echo "Useful commands:"
echo "  - Start:   sudo systemctl start apache2"
echo "  - Stop:    sudo systemctl stop apache2"
echo "  - Restart: sudo systemctl restart apache2
