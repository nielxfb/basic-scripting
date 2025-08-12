#!/bin/bash

ROOTDIR=$PWD
GITHUB_REPO="https://github.com/WillyWinata/CoreTraining-NetworkBP-WWonKHa"
DIR_NAME="CoreTraining-NetworkBP-WWonKHa/"
DIR="$PWD/$DIR_NAME"
CONF_FILE="/etc/apache2/sites-available/000-default.conf"
DB_USER="DanielAdamlu"
DB_PASS="T047"
DB_NAME="wonka"
TARGET="/var/www/$DIR_NAME"

print() {
	echo "$1"
	sleep 1
}

cleanup() {
	sudo rm -rf $DIR
	sudo rm -rf $TARGET
	sudo mysql -e "DROP DATABASE IF EXISTS $DB_NAME;"
}

clear

print "Installing required packages.."

sudo apt install -y \
	apache2 \
	php \
	php-mysqli \
	mysql-server \
	git

echo ""

cleanup

print "Cloning repository from GitHub.."

git clone $GITHUB_REPO
echo ""

sudo chown -R www-data:www-data $DIR

cd $DIR

if [[ ! -f wonka.sql ]]; then
	print "wonka.sql not found. Please reinitialize the project."
	exit
fi

echo "Creating MySQL user for $DB_USER"
sudo mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"

mysql -u "$DB_USER" -p"$DB_PASS" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < wonka.sql

cd config/

echo ""
print "Changing environment variable.."
if [[ ! -f .env ]]; then
	print ".env not found. Please reinitialize the project."
	exit
else
	sudo sed -i "s/^DB_USER=.*/DB_USER=$DB_USER/" .env
	sudo sed -i "s/^DB_PASS=.*/DB_PASS=$DB_PASS/" .env
	echo "Successfully changed environment variables"
fi

echo ""
print "Configuring Apache2.."
sudo mv $DIR $TARGET

sudo sed -i "s|^\(\s*DocumentRoot\s*\).*|\1$TARGET|" "$CONF_FILE"
sudo systemctl reload apache2

