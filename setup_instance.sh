#!/bin/bash

# Default settings for Azure
PFX_FILE_NAME=${PFX_FILE_NAME:-"webaws_pam4_com.pfx"}
APP_NAME=${APP_NAME:-"BlazorAut"}
AZURE_STORAGE_ACCOUNT="constantine2zu"
AZURE_CONTAINER_NAME="web"

# Update system and install necessary tools
sudo apt-get update
sudo apt-get install -y postgresql-client azure-cli jq
sudo apt install azure-cli -y
# Download PFX file from Azure Blob Storage
echo "!-Downloading PFX file from Azure..."
az storage blob download --container-name $AZURE_CONTAINER_NAME --name $PFX_FILE_NAME --file /etc/ssl/certs/${APP_NAME}.pfx --account-name $AZURE_STORAGE_ACCOUNT --auth-mode key --account-key ${ACC_KEY}
sudo chmod 600 /etc/ssl/certs/${APP_NAME}.pfx

# Download and setup the web application
sudo mkdir -p /var/www/${APP_NAME}
echo "!-Downloading web app executable..."
curl -L -o /var/www/${APP_NAME}/${APP_NAME} https://github.com/Constantine-SRV/BlazorAut/releases/download/build-all-20240630185327/BlazorAut
sudo chmod +x /var/www/${APP_NAME}/${APP_NAME}
sudo chmod -R 755 /var/www/${APP_NAME}/wwwroot/


# Configure app settings
APPSETTINGS_PATH="/var/www/${APP_NAME}/appsettings.json"
jq --arg db_host "$DB_HOST" \
   --arg db_user "$DB_USER" \
   --arg db_pass "$DB_PASS" \
   '.ConnectionStrings.DefaultConnection = ("Host=" + $db_host + ";Database=dbwebaws;Username=" + $db_user + ";Password=" + $db_pass)' \
   $APPSETTINGS_PATH > $APPSETTINGS_PATH.tmp && mv $APPSETTINGS_PATH.tmp $APPSETTINGS_PATH

# Setup service
echo "[Unit]
Description=${APP_NAME} Web App

[Service]
WorkingDirectory=/var/www/${APP_NAME}
ExecStart=/var/www/${APP_NAME}/${APP_NAME}
Restart=always
RestartSec=10
SyslogIdentifier=${APP_NAME}

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/${APP_NAME}.service

sudo systemctl daemon-reload
sudo systemctl enable ${APP_NAME}
sudo systemctl start ${APP_NAME}
