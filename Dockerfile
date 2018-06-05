FROM node:10.3.0-stretch

## install updates
RUN apt-get update
RUN apt-get install apt-utils -y
RUN apt-get install curl tzdata -y

ENV LANG C.UTF-8

## update NPM
RUN npm i -g npm@6.1.0

# setup working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# install dependencies
RUN buildDeps='curl ca-certificates rsync openssh-client graphicsmagick git-all' \
    && apt-get update \
    && apt-get install -y $buildDeps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# do some clean-up
RUN apt-get purge -y --auto-remove $buildDeps
# do some clean-up
RUN apt-get purge -y --auto-remove $buildDeps

# update Timezone
RUN echo Europe/Paris | tee /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

## adds Chrome to the image
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y --no-install-recommends \
    chromium \
    libgconf-2-4 \
    openjdk-8-jre-headless \
    && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN /usr/bin/chromium

CMD [ "npm", "start" ]
