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
dblist="$(mktemp)"

echo "show databases like '$user\_%';" | mysql -b | sed '1d' > $dblist 
echo "show databases like '$user%';" | mysql -b | sed '1d' > $dblist 

#create a database dump in tmpdir
for db in $(cat $dblist)
do
    mysqldump "$db" > $tmpdir/$db.sql
done

#copy docroot to tmpdir
rsync -aP /var/www/$domain/ $tmpdir

cd $tmpdir
chown -R $user. $tmpdir

tar -czvf /root/backups/$domain-$(date +%F-%s).tar.gz .

rm -rf "$tmpdir"
rm -rf "$dblist"

