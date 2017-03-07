#!/bin/bash

domain="$1"
user="$2"

if [[ "$domain" = "" ]]; then
    echo "Please supply a domain."
    exit 2
fi

if [[ "$user" = "" ]]; then
    echo "Please supply a user"
    exit 3
fi

tmpdir="$(mktemp -d)"

#create a database dump in tmpdir
mysqldump "$2" > $tmpdir/database.sql

#copy docroot to tmpdir
rsync -aP /var/www/$domain/ $tmpdir

cd $tmpdir
chown -R $user. $tmpdir

tar -czvf /root/backups/$domain-$(date +%F-%s).tar.gz .

rm -rf "$tmpdir"

