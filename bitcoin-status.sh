#!/bin/bash
#title			:bitcoin-status..sh
#description	:This scripts continuously displays bitcoin price from Bitstamp.net market (value of one BTC in USD) and the latest block height and age from BlockChain.info.
#author			:Kristjan Kaitsa
#date			:20140213
#version		:1.2.0
#usage:			:bash bitcoin-status.sh
#notes:			:Install cURL and Jshon to use the script. Press Ctrl+C to exit script.
#bash_version:	:4.2-5ubuntu3

#TODO:
#* colours

# Check those variables and make your modifications if necessary:

# Public API URLs
BITSTAMP_API_URL="https://www.bitstamp.net/api/ticker/"
BLOCKCHAIN_API_URL="https://blockchain.info/latestblock"

TIME_FORMAT="%H:%M %e.%d.%Y" # format in what you want timestamp to be, check for variables: http://www.linuxmanpages.com/man1/date.1.php
INTERVAL=60 # in seconds, set it by checking API request limits
SKIP_BLOCKCHAIN_INVERVALS=4 # How many invevals skip blockchain request. E.g. if 0, then every interval (default 60s) is blockchain request made; if 1, then every other interval (skip one interval) and so on. May be necessary, because difference in API request limits.
SKIP_BITSTAMP_INTERVALS=1 # Same as 'SKIP_BLOCKCHAIN_INVERVAlS', but for Bitstamp requests.

# Don't modify code beneath this comment unless you know what you're doing ;).

echo "Current BTC price from Bitstamp.net."
echo "Lastest block info from Blockchain.info."
echo -e "Update interval: "$INTERVAL" seconds."

COUNTER=0

# don't want to use 'watch', because it runs in full screen mode
while true; do
	if [ "$SKIP_BITSTAMP_INTERVALS" -eq 0 ] || [ "$(($COUNTER % ($SKIP_BITSTAMP_INTERVALS + 1)))" -eq 0 ] ; then
		PRICE=`curl --get --silent $BITSTAMP_API_URL | jshon -e last -u`
	fi
	if [ "$SKIP_BLOCKCHAIN_INVERVALS" -eq 0 ] || [ "$(($COUNTER % ($SKIP_BLOCKCHAIN_INVERVALS + 1)))" -eq 0 ] ; then
		BLOCKCHAIN_OUTPUT=`curl --get --silent $BLOCKCHAIN_API_URL`
		HEIGHT=`echo $BLOCKCHAIN_OUTPUT | jshon -e height -u`
		TIME=`echo $BLOCKCHAIN_OUTPUT | jshon -e time -u`
	fi
	
	TIME_CURRENT_UTC=`TZ='UTC' date +%s`
	TIME_DELTA=`echo "$TIME_CURRENT_UTC-$TIME" | bc`
	TIME_DELTA_HUMAN="$(($TIME_DELTA / 60))m $(($TIME_DELTA % 60))s"
	
	echo -ne "\n[" && echo -n `date +"$TIME_FORMAT"` && echo -ne "] LAST PRICE: $"$PRICE"\tHEIGHT: "$HEIGHT"\tAGE: "$TIME_DELTA_HUMAN
	
	sleep $INTERVAL
	
	let COUNTER++
done

