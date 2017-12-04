#!/bin/bash

domain=$1
user=$2

docroot="/var/www/$domain"
conf="/etc/apache2/sites-available/$domain.conf"

echo -e "I'll try to create a site with domain '$domain' and matching user '$user'.\n"

echo -n "Creating new user and user-group..."
useradd -M -U -s /bin/nologin "$user"
echo "Done!"

echo -n "Creating new document in '$docroot'..."
mkdir -p "$docroot"
echo "Done!"

echo -n "Creating new apache config '$conf'..."
cp "/root/templates/site-template.conf" "/etc/apache2/sites-available/$domain.conf"
sed -i "s/{domain}/$domain/g" "$conf"
sed -i "s/{user}/$user/g" "$conf"
echo "Done!"

echo -n "Creating test page at '$docroot/index.php'..."
echo "<?php phpinfo(); ?>" > $docroot/index.php
chown -R $user. $docroot
echo "Done!"

a2ensite $domain

echo -n "Reloading Apache..."
service apache2 reload
echo "Done!"

echo "Test site should be available at 'http://$domain' (barring DNS fuckups)."
