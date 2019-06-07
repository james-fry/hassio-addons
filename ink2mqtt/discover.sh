#!/bin/bash

# A simple script that will call ink

export LANG=C
PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

CONFIG_PATH=/data/options.json
PRINTERIP="$(jq --raw-output '.printer_ip' $CONFIG_PATH)"

ink -b bjnp://$PRINTERIP
