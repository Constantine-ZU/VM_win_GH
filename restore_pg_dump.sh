#!/bin/bash

DB_HOST=${DB_HOST:-"pgaz.pam4.com"}
DB_USER=${DB_USER:-"dbuser"}
DB_PASS=${DB_PASS:-"password"}
DB_NAME=${DB_NAME:-"dbwebaws"}
ST_ACCOUNT=${ST_ACCOUNT:-"constantine2zu"}
ACC_KEY=${ACC_KEY:-"XXX"}

#DUMP_FILE_PATH="${S3_BUCKET}${DB_NAME}_backup.dump"

echo "!-apt-get update"
sudo apt-get update
sudo apt-get install -y postgresql-client

echo "!- Setup az-cli"
sudo apt install azure-cli -y


echo "!-Downloading database dump from S3..."
az storage blob download --container-name web --name dbwebaws_backup.dump --file ~/dbwebaws_backup.dump --account-name constantine2zu --auth-mode key --account-key ${ACC_KEY}
#aws s3 cp ${DUMP_FILE_PATH} ~/dbwebaws_backup.dump


# echo "!-Waiting for the PostgreSQL database to become ready..."
# max_attempts=50
# attempt_no=0
echo "!-Pg_Dump arguments Length of DB_PASS: ${#DB_PASS}, First three characters: ${DB_PASS:0:3}"
#PGPASSWORD=$DB_PASS

echo "!-Restoring database from dump..."
PGPASSWORD=$DB_PASS pg_restore -h $DB_HOST -U $DB_USER -d $DB_NAME -v ~/dbwebaws_backup.dump || echo "Failed to restore database"


echo "1-Database restoration complete."
