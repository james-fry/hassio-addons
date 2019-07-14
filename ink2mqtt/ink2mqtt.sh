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

ink -b bjnp://$PRINTERIP
echo "-------------------------------------------"
mapfile -t lines < <(ink -b bjnp://$PRINTERIP | cut -d: -f1)
if [ "${lines[2]}" != "" ]; then
   PRINTER=${lines[2]}
   BRAND=$(echo $PRINTER | awk -F' ' '{ print $1 }')
   TYPE=$(echo $PRINTER | awk -F' ' '{ print $2 }')
   EXTRA=$(echo $PRINTER | awk -F' ' '{ print $3 }')
   json_attributes=()
   numlines=${#lines[@]}
    for (( i=4; i<=$numlines-1; i++ ))
    do
      json_attributes+=("${lines[i]}")
    done
fi

# Start the listener and enter an endless loop
echo "Parameters:"
echo "MQTT Host =" $MQTT_HOST
echo "Printer IP address =" $PRINTERIP
echo "Sleep interval =" $INTERVAL
echo "Brand = " $BRAND
echo "Type = " $TYPE
echo "Extra = " $EXTRA
echo "-------------------------------------------"
#set -x  ## uncomment for MQTT logging...

echo "MQTT autodiscovery for all ink colours:"
#json_attributes=(Black Color)
for i in "${json_attributes[@]}"
do
  echo "$i"
  #AUTO_D="{\"unit_of_measurement\":\"%\",\"icon\":\"mdi:water\",\"value_template\":\"{{ value_json.$i }}\",\"state_topic\":\"ink2mqtt/"$BRAND""$TYPE"\",\"name\":\"$BRAND $TYPE $i Ink Level\",\"unique_id\":\"$BRAND $TYPE series_"$i"_ink2mqtt\",\"device\":{\"identifiers\":\"$BRAND $TYPE series\",\"name\":\"$BRAND $TYPE series\",\"sw_version\":\"2.020\",\"model\":\"$TYPE series\",\"manufacturer\":\"$BRAND\"}}"
  AUTO_D="{\"unit_of_measurement\":\"%\",\"icon\":\"mdi:water\",\"value_template\":\"{{ value_json.$i }}\",\"state_topic\":\"ink2mqtt/"$BRAND""$TYPE"\",\"name\":\"$BRAND $TYPE $i Ink Level\",\"unique_id\":\"$BRAND $TYPE $EXTRA_"$i"_ink2mqtt\",\"device\":{\"identifiers\":\"$BRAND $TYPE $EXTRA\",\"manufacturer\":\"$BRAND\",\"model\":\"$TYPE $EXTRA\"}}"
  echo $AUTO_D
  #echo $AUTO_D | mosquitto_pub -h $MQTT_HOST -u $MQTT_USER -P $MQTT_PASS -i ink2mqtt -r -l -t homeassistant/sensor/"$BRAND"_"$TYPE"/$i/config
  echo
done

echo
echo "Using Ink to read device every "$INTERVAL" seconds, and send to MQTT"
echo

while true; do
  mapfile -t lines < <(ink -b bjnp://$PRINTERIP)
  if [ "${lines[2]}" != "" ]; then
     payload='{ \"Device: \"${lines[2]}\"'
     numlines=${#lines[@]}
     for (( i=4; i<=$numlines-1; i++ ))
     do
       payload=$payload', \"${lines[i]%\%}\"'
     done
     payload=$payload' }'
     datetime=`date`
     echo $datetime " -- " $payload | sed -e 's/: /": /g'
     #echo $payload | sed -e 's/: /": /g'  | /usr/bin/mosquitto_pub -h $MQTT_HOST -u $MQTT_USER -P $MQTT_PASS -i ink2mqtt -r -l -t ink2mqtt/"$BRAND""$TYPE"
     sleep $INTERVAL
  fi  
done
