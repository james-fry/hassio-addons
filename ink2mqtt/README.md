# Ink to MQTT Bridge hass.io addon - BETA
Query network printer using Ink (http://ink.sourceforge.net/) and send ink levels via MQTT

Tested with my Canon Pixma MG5300 printer and with a Canon Pixma MG7500 printer by bouwew.

# Instructions:
1) Deploy the hassio addon.
2) Create a new dir in the hassio config dir called ink2mqtt
3) Download the discover.sh shell script from the repo into that dir. NOTE - this will only work from the SSH-command-prompt!
4) Enter valid data for the addon Config:
```
  "mqtt_host": "192.168.x.xyz",
  "mqtt_user": "your username",
  "mqtt_password": "your password",
  "printer_ip": "your printer IP", #best make sure this is a fixed IP,
  "interval": 3600 #or any number you like
```
5) Start the addon
6) Scroll down to where the log is shown. Notice the printer name: "BRAND TYPE series" and the names of the CARTRIDGES.
7) Stop the addon.
8) Download the ink2mqtt.sh shell script from the repo into the config/ink2mqtt dir. Again, via SSH.
9) Open the file ink2mqqt.sh in the Home Assistant editor and adjust the following text:
"BRAND"="Canon" - replace Canon by your printer BRAND as found at step 6.
"TYPE"="MG7500" - replace MG7500 by your printer TYPE as found at step 6.
Change this line: "json_attributes=(Black Photoblack Yellow Magenta Cyan Photogrey)", replace the list of names/colors between the ( ) by the names of the CARTRIDGES found at step 6, in the same order as shown in the log, from top to bottom.
Now, save the file.
10) Finally, start the addon once more. Scroll down to the log-area for the result.

I am very aware that the ink2mqtt.sh shell script is far from production ready. Its hacked together but works for my printer.
The ink2mqtt.sh shell script supports HA MQTT autodiscovery, but only for my Canon Pixma 5300 series - it is very hard-coded.
