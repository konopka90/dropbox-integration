#!/usr/bin/env bash

source ./configuration

FILENAME=$(date +"%Y-%m-%d_%H-%M-%S").sql

mysqldump -u "$DB_USER" --password="$DB_PASSWORD" -h "$DB_HOST" -P "$DB_PORT" "$DB_DATABASE"  > "$FILENAME"
if [ $? -ne 0 ]; then
  rm "$FILENAME"
  exit 1
else
  echo "DB CONNECTION OK"
fi

./dropbox_uploader.sh -f ./configuration upload "$FILENAME" .
rm "$FILENAME"
