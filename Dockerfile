FROM ubuntu:22.04

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
RUN apt-get install -qy openjdk-11-jdk

# install rsync
RUN apt-get install -qy rsync

# install node
RUN apt-get install -qy unzip curl
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -qy nodejs

# update npm
RUN npm install -g npm@9.2.0

# install angular cli

RUN npm install -g @angular/cli@latest

# install chrome headless

RUN npm install -g -D karma-chrome-launcher puppeteer
RUN apt-get install -qy libappindicator1 fonts-liberation libgbm1 libgtk-4-1 libxkbcommon0 xdg-utils
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome*.deb

# Cleanup old packages
RUN apt-get -qy autoremove

# Add user jenkins to the image
RUN adduser --disabled-password --gecos "" jenkins 

# fix java

RUN ln -s /usr/lib/jvm/java-11-openjdk-amd64/ /home/jenkins/jdk
RUN chown jenkins:jenkins /home/jenkins/jdk

COPY resources/xdebug.ini /etc/php/8.1/mods-available/xdebug.ini

CMD ["sleep", "99D"]
