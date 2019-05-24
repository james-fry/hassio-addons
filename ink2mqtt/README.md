# Ink to MQTT Bridge hass.io addon - BETA
Query network printer using Ink (http://ink.sourceforge.net/) and send ink levels via MQTT

Tested with Canon Pixma MG5300 Printer only

# Instructions:
1) Deploy the hassio addon
2) Create a dir in the hassio config dir called ink2mqtt
3) Copy the ink2mqtt.sh shell script from the repo into that dir
4) Edit the ink2mqtt.sh shell script if/as needed for your printer

I am very aware that the ink2mqtt.sh shell script is far from production ready. Its hacked together but works for my printer.
The ink2mqtt.sh shell script supports HA MQTT autodiscovery, but only for my Canon Pixma 5300 series - it is very hard-coded.
