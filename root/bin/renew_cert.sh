#!/bin/bash

#configuration
expiration_cutoff=90 #minimum number of days before expiration to renew the cert
dev_webroot="/home/cam/cl-exacta.git/webroot"
production_webroot="/var/www/$1"
haproxy_cert_dir="/etc/haproxy/certs"

domain=$1
letsencrypt_basedir=/etc/letsencrypt
certfile="$letsencrypt_basedir/live/$domain/cert.pem"

#webroot is different on the dev box:
if [[ -d "$dev_webroot" ]]
then
    webroot=$dev_webroot
else
    webroot=$production_webroot
fi

#debian perversely still calls the certbot binary by 'letsencrypt'

if hash certbot 2>/dev/null
then
    certbot_binary="certbot"
else
    certbot_binary="letsencrypt"
fi

#when does the cert expire?
if [[ -e "$certfile" ]]
then
    timestamp_now=$(date -d "now" +%s)
    expiration_timestamp=$(date -d "`openssl x509 -in $certfile -text -noout|grep "Not After"|cut -c 25-`" +%s)
    days_until_expiration=$(echo \( $expiration_timestamp - $timestamp_now \) / 86400 |bc)
else
    days_until_expiration=0 # if there's no cert on file at all, assume it expires today, forcing a renewal
fi

#if it expires soon... 
if [[ "$days_until_expiration" -lt "$expiration_cutoff" ]]
then
    #...get the cert from letsencrypt...
    if  $certbot_binary certonly \
			--webroot \
			--keep-until-expiring \
			--email "inquiries@exactatechnologies.com" \
			--agree-tos \
			-w $webroot \
			-d $domain
    then
	#...if successful cat the chain and privkey files together because HAproxy needs them as one file
	cat /etc/letsencrypt/live/$domain/fullchain.pem \
	    /etc/letsencrypt/live/$domain/privkey.pem > $haproxy_cert_dir/$domain.pem

	#...and reload the HAproxy config
	service haproxy restart
    fi                         
fi
