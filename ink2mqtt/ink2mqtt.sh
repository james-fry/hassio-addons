#!/bin/bash

# A simple script that will call ink and send the data via MQTT

export LANG=C
PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

CONFIG_PATH=/data/options.json
MQTT_HOST="$(jq --raw-output '.mqtt_host' $CONFIG_PATH)"
MQTT_USER="$(jq --raw-output '.mqtt_user' $CONFIG_PATH)"
MQTT_PASS="$(jq --raw-output '.mqtt_password' $CONFIG_PATH)"
PRINTERIP="$(jq --raw-output '.printer_ip' $CONFIG_PATH)"
INTERVAL="$(jq --raw-output '.interval' $CONFIG_PATH)"


# Start the listener and enter an endless loop
echo "Parameters:"
echo "MQTT Host =" $MQTT_HOST
echo "MQTT User =" $MQTT_USER
echo "MQTT Password =" $MQTT_PASS
echo "Printer IP address =" $PRINTERIP
echo "Sleep interval =" $INTERVAL
echo
#set -x  ## uncomment for MQTT logging...

echo "MQTT autodiscovery for all ink colours:"
json_attributes=(Black Photoblack Yellow Magenta Cyan)
for i in "${json_attributes[@]}"
do
  echo "$i"
  AUTO_D="{\"unit_of_measurement\":\"%\",\"icon\":\"mdi:water\",\"value_template\":\"{{ value_json.$i }}\",\"state_topic\":\"ink2mqtt/CanonMG5300\",\"json_attributes_topic\":\"ink2mqtt/CanonMG5300\",\"name\":\"Canon MG5300 $i Ink Level\",\"unique_id\":\"Canon MG5300 series_"$i"_ink2mqtt\",\"device\":{\"identifiers\":\"Canon MG5300 series\",\"name\":\"Canon MG5300 series\",\"sw_version\":\"2.030\",\"model\":\"MG5300 series\",\"manufacturer\":\"Canon\"}}"
  echo $AUTO_D
  echo $AUTO_D | mosquitto_pub -h $MQTT_HOST -u $MQTT_USER -P $MQTT_PASS -i ink2mqtt -r -l -t homeassistant/sensor/Canon_MG5300/$i/config
  echo
done

echo
echo "Using Ink to read device every "$INTERVAL" seconds, and send to MQTT"
echo

while true; do
  mapfile -t lines < <(ink -b bjnp://$PRINTERIP)
  payload="{ \"Device: \"${lines[2]}\""
  numlines=${#lines[@]}
  for (( i=4; i<=$numlines-1; i++ ))
  do
    payload=$payload", \"${lines[i]%\%}"
  done
  payload=$payload" }"
  datetime=`date`
  echo $datetime " -- " $payload | sed -e 's/: /": /g'
  echo $payload | sed -e 's/: /": /g'  | /usr/bin/mosquitto_pub -h $MQTT_HOST -u $MQTT_USER -P $MQTT_PASS -i ink2mqtt -r -l -t ink2mqtt/CanonMG5300
  sleep $INTERVAL
done
