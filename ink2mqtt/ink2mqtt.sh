#!/bin/sh

# A simple script that will call resend the data via MQTT

export LANG=C
PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

CONFIG_PATH=/data/options.json
MQTT_HOST="$(jq --raw-output '.mqtt_host' $CONFIG_PATH)"
MQTT_USER="$(jq --raw-output '.mqtt_user' $CONFIG_PATH)"
MQTT_PASS="$(jq --raw-output '.mqtt_password' $CONFIG_PATH)"
MQTT_TOPIC="$(jq --raw-output '.mqtt_topic' $CONFIG_PATH)"
PRINTERIP="$(jq --raw-output '.printer_ip' $CONFIG_PATH)"
INTERVAL="$(jq --raw-output '.interval' $CONFIG_PATH)"


# Start the listener and enter an endless loop
echo "Calling ink with parameters:"
echo "MQTT Host =" $MQTT_HOST
echo "MQTT User =" $MQTT_USER
echo "MQTT Password =" $MQTT_PASS
echo "MQTT Topic =" $MQTT_TOPIC
echo "Printer IP address =" $PRINTERIP
echo "Sleep interval =" $INTERVAL

set -x  ## uncomment for MQTT logging...

while true; do
  /usr/local/bin/ink -b bjnp://$PRINTERIP
#do
#  DEVICE="$(echo $line | jq --raw-output '.model' | tr -s ' ' '_')" # replace ' ' with '_'
#  DEVICEID="$(echo $line | jq --raw-output '.id' | tr -s ' ' '_')"
#
#  MQTT_PATH=$MQTT_TOPIC
#
#  if [ ${#DEVICE} > 0 ]; then
#    MQTT_PATH=$MQTT_PATH/"$DEVICE"
#  fi
#  if [ ${#DEVICEID} > 0 ]; then
#    MQTT_PATH=$MQTT_PATH/"$DEVICEID"
#  fi

  # Create file with touch /tmp/rtl_433.log if logging is needed
#  [ -w /tmp/rtl_433.log ] && echo $line >> rtl_433.log
#  echo $line | /usr/bin/mosquitto_pub -h $MQTT_HOST -u $MQTT_USER -P $MQTT_PASS -i RTL_433 -r -l -t $MQTT_PATH
  sleep $INTERVAL
done
