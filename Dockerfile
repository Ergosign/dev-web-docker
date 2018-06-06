FROM node:10.3.0-alpine

LABEL Description="This image is during development of Ergosign Web Projects, setting up the standard development environment" Vendor="Ergosign GmbH" Version="1.0.0"

# Update apk repositories
RUN echo "http://dl-2.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories
RUN echo "http://dl-2.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN echo "http://dl-2.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Install chromium
RUN apk -U --no-cache \
	--allow-untrusted add \
    zlib-dev \
    chromium \
    xvfb \
    wait4ports \
    xorg-server \
    dbus \
    ttf-freefont \
    mesa-dri-swrast \
    grep \ 
    udev \
    && apk del --purge --force linux-headers binutils-gold gnupg zlib-dev libc-utils \
    && rm -rf /var/lib/apt/lists/* \
    /var/cache/apk/* \
    /usr/share/man \
    /tmp/* \
    /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc \
    /usr/lib/node_modules/npm/html \
    /usr/lib/node_modules/npm/scripts

# Add Chrome as a user
RUN adduser -D chrome \
    && chown -R chrome:chrome /usr/src/app
# Run Chrome non-privileged
USER chrome

ENV CHROME_BIN /usr/bin/chromium-browser
ENV CHROME_PATH /usr/lib/chromium/

ENV LANG C.UTF-8

## update NPM
RUN npm i -g npm@6.1.0

# setup working directory
RUN mkdir -p /usr/dev/app
WORKDIR /usr/dev/app

# update Timezone
RUN echo Europe/Paris | tee /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

EXPOSE 4200/tcp
EXPOSE 4201/tcp
EXPOSE 4202/tcp

CMD [ "npm", "start" ]
