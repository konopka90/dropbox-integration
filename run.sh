#!/usr/bin/env bash

source ./configuration

CURRENT_DATE=$(date +"%Y-%m-%d_%H-%M-%S")
SQL_FILENAME="$CURRENT_DATE.sql"
BACKUP_FILENAME="$CURRENT_DATE.tar.gz"

# Dump database

mysqldump -u "$DB_USER" --password="$DB_PASSWORD" -h "$DB_HOST" -P "$DB_PORT" "$DB_DATABASE"  > "$SQL_FILENAME"
if [ $? -ne 0 ]; then
  rm "$SQL_FILENAME"
  exit 1
else
  echo "DB CONNECTION OK"
fi

# Compress files

tar -zcvf "$BACKUP_FILENAME" "$PATH_TO_COMPRESS" "$SQL_FILENAME"

./dropbox_uploader.sh -f ./configuration upload "$BACKUP_FILENAME" .

rm "$SQL_FILENAME"
rm "$BACKUP_FILENAME"