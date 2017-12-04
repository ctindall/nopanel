#!/bin/bash

find  /var/www/ -maxdepth 1 -type d -printf '%f\t%u\n' | grep -v ^\\. | grep -v ^html$ | grep -v ^htpasswd$
