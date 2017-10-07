ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install requirements for add-on
RUN apk add --no-cache libpcap-dev jq git nodejs nodejs-npm python make g++

#install dasher
RUN cd /root && export GIT_SSL_NO_VERIFY=1 && \
    git config --global http.sslVerify false && \
    git clone https://github.com/maddox/dasher.git

WORKDIR /root/dasher
RUN cd /root/dasher && npm install

# Copy data for add-on
#COPY run.sh /
#RUN chmod a+x /run.sh

#CMD [ "/run.sh" ]
CMD cd /root/dasher && cp /config/dasher/config.json /root/dasher/config/config.json && npm run start
