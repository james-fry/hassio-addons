# RTL433 to MQTT Bridge hass.io addon
A hass.io addon for a software defined radio tuned to listen for 433MHz RF transmissions and republish the data via MQTT

This hass.io addon is based on Chris Kacerguis' project here: https://github.com/chriskacerguis/honeywell2mqtt,
which is in turn based on Marco Verleun's rtl2mqtt image here: https://github.com/roflmao/rtl2mqtt

## Usage

1) Install the addon.

2) Use addon configuration to configure:
- mqtt_host
- mqtt_user
- mqtt_password
- mqtt_topic
- protocol (see https://github.com/merbanan/rtl_433 for more details inc protocol IDs)

3) Copy rtl2mqtt.sh to your hass.io config dir in a subdir called rtl4332mqtt.
i.e.
.../config/rtl4332mqtt/rtl2mqtt.sh
This allows you to edit the start script if you need to make any changes

NOTE that some people have reported issues using samba to copy the script. For some reason it does not get copied to the container on start up of the addon. If you see this issue, please scp the script to your hassio config folder, or ssh in and edit the file locally with vi/nano.

Also there is now an example rtl2mqtt script with MQTT sensor autodiscovery. This is very hard coded to a single sensor currentcost, but might be an interesting example for others to repurpose...


4) Start the addon


## MQTT Data

Data to the MQTT server will depend on the protocol.
Chris tested Honeywell devices and the JSON is as follows:

```json
{
    "time" : "2017-08-17 13:18:58",
    "model" : "Honeywell Door/Window Sensor",
    "id" : 547651,
    "channel" : 8,
    "event" : 4,
    "state" : "closed",
    "heartbeat" : "yes"
}
```

I have tested CurrentCost devices and the JSON is as follows:

```json
{
    "time" : "2017-10-16 20:53:09",
    "model" : "CurrentCost TX",
    "dev_id" : 3063,
    "power0" : 617,
    "power1" : 0,
    "power2" : 0
}
```

## Hardware

This has been tested and used with the following hardware (you can get it on Amazon)

Chris:
- Honeywell Ademco 5818MNL Recessed Door Transmitter
- 5800MINI Wireless Door/Window Contact by Honeywell
- NooElec NESDR Nano 2+ Tiny Black RTL-SDR USB

Me:
- CurrentCost TX: http://www.ebay.co.uk/itm/Current-Cost-Envi-R-Energy-Monitor-Smart-Electric-Meter-/152084708754
- Super cheap RTL dongle: http://www.ebay.co.uk/itm/Mini-USB-DVB-T-RTL-SDR-Realtek-RTL2832U-R820T-Stick-Receiver-Dongle-MCX-Input-PK/222637370515


## Troubleshooting

If you see this error:

> Kernel driver is active, or device is claimed by second instance of librtlsdr.
> In the first case, please either detach or blacklist the kernel module
> (dvb_usb_rtl28xxu), or enable automatic detaching at compile time.

Then run the following command on the host

```bash
sudo rmmod dvb_usb_rtl28xxu rtl2832
```
