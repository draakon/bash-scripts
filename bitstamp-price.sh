#!/bin/bash
#title			:bitstamp-price.sh
#description	:This scripts continuously displays bitcoin price from Bitstamp.net market (value of one BTC in USD).
#author			:Kristjan Kaitsa
#date			:20140128
#version		:1.0.0
#usage:			:bash bitstamp-price.sh
#notes:			:Install cURL and Jshon to use the script. Press Ctrl+C to exit script.
#bash_version:	:4.2-5ubuntu3

TIME_FORMAT="%H:%M %e.%d.%Y"
API_URL="https://www.bitstamp.net/api/ticker/" # public API url
INTERVAL=60 # in seconds

echo "Current BTC price from Bitstamp.net."
echo -e "Update interval: "$INTERVAL" seconds."

# don't want to use 'watch', because it runs in full screen mode
while true; do
	PRICE=`curl --get --silent $API_URL | jshon -e last -u`
	echo && echo -n `date +"$TIME_FORMAT"` && echo -n ": $"$PRICE
	sleep $INTERVAL
done

