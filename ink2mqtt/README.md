# Ink to MQTT Bridge hass.io addon - BETA
Query network printer using Ink (http://ink.sourceforge.net/) and send ink levels via MQTT

Tested with my Canon Pixma MG5300 printer and with Canon Pixma printers MG7550 and MG3550 by bouwew.

# Instructions:
1) Deploy the hassio addon.
2) Create a new dir in the hassio config-directory called ink2mqtt
3) Download the ink2mqtt.sh shell-script from the repo into this dir. NOTE - this will only work from the SSH-command-prompt!
4) Enter valid data for the addon Config:
```
  "mqtt_host": "192.168.x.xyz", # can also be a hostname
  "mqtt_user": "your mqtt username",
  "mqtt_password": "your mqtt password",
  "printer_ip": "your printer IP", # best make sure this is a fixed IP,
  "interval": 3600 #o r any number you like
```
5) Start the addon

Enjoy!
