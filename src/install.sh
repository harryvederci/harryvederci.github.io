set -e

pip3 install -U -r requirements.txt --user

mkdir -p .data

./create-db.sql

