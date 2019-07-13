# Docker file to create an image for a hass.io add-on that contains enough software to query a network printer via <ink> and publish the ink levels to a MQTT broker.

ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

MAINTAINER James Fry

LABEL Description="This image is used to start a script that will monitor for RF events on 433Mhz (configurable) and send the data to an MQTT server"

#
# First install software packages needed to compile rtl_433 and to publish MQTT events
#
RUN \
apk add --no-cache --virtual build-deps alpine-sdk cmake libusb-dev && \
mkdir /tmp/src && \
cd /tmp/src && \
curl -L http://downloads.sourceforge.net/libinklevel/libinklevel-0.9.3.tar.gz > libinklevel-0.9.3.tar.gz && \
tar xvfz libinklevel-0.9.3.tar.gz && \
cd libinklevel-0.9.3 && \
./configure && \
make && \
make install && \
cd /tmp/src && \
curl -L http://downloads.sourceforge.net/ink/ink-0.5.3.tar.gz > ink-0.5.3.tar.gz && \
tar xvfz ink-0.5.3.tar.gz && \
cd ink-0.5.3 && \
./configure && \
make && \
make install && \
apk add --no-cache mosquitto-clients jq

#
# Define an environment variable
#
# Use this variable when creating a container to specify the MQTT broker host.
ENV MQTT_HOST="hassio.local"
ENV MQTT_USER="guest"
ENV MQTT_PASS="guest"
ENV MQTT_TOPIC="homeassistant/sensor/ink"

COPY rootfs /

CMD cd / && cp /config/ink2mqtt/ink2mqtt.sh /ink2mqtt.sh && chmod +x /ink2mqtt.sh && /ink2mqtt.sh
