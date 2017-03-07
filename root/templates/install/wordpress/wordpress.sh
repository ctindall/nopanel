#!/bin/bash

domain="$1"
user="$2"
password="$(pwgen 24 1)"

rsync -avP "/root/templates/homedir/wordpress/" "/var/www/$domain"

echo  "create database $user;\
create user $user;\
grant all privileges on $user.* to '$user'@'localhost';
set password for '$user'@'localhost' = password('$password');" | mysql

sed -i "s/database_name_here/$user/" /var/www/$domain/wp-config.php
sed -i "s/username_here/$user/" /var/www/$domain/wp-config.php
sed -i "s/password_here/$password/" /var/www/$domain/wp-config.php

sed -i "s/{auth_key_here}/$(pwgen 24 1)/" /var/www/$domain/wp-config.php
sed -i "s/{secure_auth_key_here}/$(pwgen 24 1)/" /var/www/$domain/wp-config.php
sed -i "s/{logged_in_key_here}/$(pwgen 24 1)/" /var/www/$domain/wp-config.php
sed -i "s/{nonce_key_here}/$(pwgen 24 1)/" /var/www/$domain/wp-config.php
sed -i "s/{auth_salt_here}/$(pwgen 24 1)/" /var/www/$domain/wp-config.php
sed -i "s/{secure_auth_salt_here}/$(pwgen 24 1)/" /var/www/$domain/wp-config.php
sed -i "s/{logged_in_salt}/$(pwgen 24 1)/" /var/www/$domain/wp-config.php
sed -i "s/{nonce_salt}/$(pwgen 24 1)/" /var/www/$domain/wp-config.php

chown -R $user. /var/www/$domain
