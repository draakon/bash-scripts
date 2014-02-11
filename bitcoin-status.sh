#!/bin/bash
#title			:bitcoin-status..sh
#description	:This scripts continuously displays bitcoin price from Bitstamp.net market (value of one BTC in USD) and the latest block height and age from BlockChain.info.
#author			:Kristjan Kaitsa
#date			:20140211
#version		:1.1.0
#usage:			:bash bitcoin-status.sh
#notes:			:Install cURL and Jshon to use the script. Press Ctrl+C to exit script.
#bash_version:	:4.2-5ubuntu3

#TODO:
#* colours

TIME_FORMAT="%H:%M %e.%d.%Y"
# Public API URLs
BITSTAMP_API_URL="https://www.bitstamp.net/api/ticker/"
BLOCKCHAIN_API_URL="https://blockchain.info/latestblock"
INTERVAL=60 # in seconds

s
echo "Current BTC price from Bitstamp.net."
echo "Lastest block info from Blockchain.info."
echo -e "Update interval: "$INTERVAL" seconds."

# don't want to use 'watch', because it runs in full screen mode
while true; do
	TIME_CURRENT_UTC=`TZ='UTC' date +%s`
	PRICE=`curl --get --silent $BITSTAMP_API_URL | jshon -e last -u`
	BLOCKCHAIN_OUTPUT=`curl --get --silent $BLOCKCHAIN_API_URL`
	HEIGHT=`echo $BLOCKCHAIN_OUTPUT | jshon -e height -u`
	TIME=`echo $BLOCKCHAIN_OUTPUT | jshon -e time -u`
	TIME_DELTA=`echo "$TIME_CURRENT_UTC-$TIME" | bc`
	TIME_DELTA_HUMAN="$(($TIME_DELTA / 60))m $(($TIME_DELTA % 60))s"

	echo -ne "\n[" && echo -n `date +"$TIME_FORMAT"` && echo -ne "] LAST PRICE: $"$PRICE"\tHEIGHT: "$HEIGHT"\tAGE: "$TIME_DELTA_HUMAN
	sleep $INTERVAL
done

