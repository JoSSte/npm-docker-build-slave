FROM debian:stable-slim

LABEL maintainer="Jonas Stevnsvig <jonas@kodeninjaer.dk>"

ENV TZ=Europe/Copenhagen
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ARG DEBIAN_FRONTEND=noninteractive
#RUN apt-get install -qy --no-install-recommends tzdata

RUN apt-get autoremove
RUN apt-get clean

# Make sure the package repository is up to date.
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy git

# install java for Jenkins
RUN apt-get install -qy openjdk-17-jdk

# install rsync
RUN apt-get install -qy rsync

# install node
RUN apt-get install -qy unzip curl wget 
RUN apt-get update && apt-get install -y ca-certificates curl gnupg
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install nodejs -y

# update npm
RUN npm install -g npm@9.2.0

# install angular cli

RUN npm install -g @angular/cli@latest

# install chrome headless

RUN npm install -g -D karma-chrome-launcher puppeteer
RUN apt-get install -qy libappindicator1 fonts-liberation libgbm1 libgtk-4-1 libxkbcommon0 xdg-utils libu2f-udev libvulkan1
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome*.deb

# Cleanup old packages
RUN apt-get -qy autoremove

# Add user jenkins to the image
RUN adduser --disabled-password --gecos "" jenkins 

# fix java

RUN ln -s /usr/lib/jvm/java-17-openjdk-amd64/ /home/jenkins/jdk
RUN chown jenkins:jenkins /home/jenkins/jdk

COPY resources/xdebug.ini /etc/php/8.1/mods-available/xdebug.ini

CMD ["sleep", "99D"]
