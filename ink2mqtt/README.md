# Ink to MQTT Bridge hass.io addon - BETA
Query network printer using Ink (http://ink.sourceforge.net/) and send ink levels via MQTT

Tested with my Canon Pixma MG5300 printer and with Canon Pixma printers MG7550 and MG3550 by bouwew.

# Instructions:
1) Deploy the hassio addon.
2) Enter valid data into the addon Config:
```
  "mqtt_host": "MQTT broker IP address"  # can also be a hostname
  "mqtt_user": "MQTT-username"
  "mqtt_password": "MQTT-password"
  "printer_ip": "Printer IP",            # best make sure this is a fixed IP,
  "interval": 3600                       # or any number you like
```
5) Start the addon

Enjoy!
