FROM ruby:2.3.1
MAINTAINER Matthieu Aussaguel
LABEL Description="Ruby / PhantomJS"

# general
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get update
RUN apt-get install gcc g++ make curl zlib1g zlib1g-dev vim openssl libcurl4-openssl-dev libreadline6-dev unzip libffi-dev -y --force-yes
RUN apt-get install libssl-dev libpcrecpp0 libpcre3-dev wget git libreadline-dev libqtwebkit-dev xvfb imagemagick -y --force-yes
RUN apt-get install libsasl2-2 libsasl2-dev libpq-dev -y --force-yes
RUN mkdir /root/src

# phantomjs
ENV PHANTOMJS_VERSION 2.1.1
RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y vim git wget libfreetype6 libfontconfig bzip2 && \
  mkdir -p /srv/var && \
  wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
  rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /srv/var/phantomjs && \
  ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs && \
  git clone https://github.com/n1k0/casperjs.git /srv/var/casperjs && \
  ln -s /srv/var/casperjs/bin/casperjs /usr/bin/casperjs && \
  apt-get autoremove -y && \
  apt-get clean all

# firefox
RUN apt-get update && apt-get install firefox -y --force-yes --fix-missing
RUN echo "DISPLAY=:99.0" | tee -a /etc/environment

# node
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN npm install -g bower

# postgres
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*
