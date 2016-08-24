FROM ruby:2.3.1
MAINTAINER Matthieu Aussaguel
LABEL Description="Ruby / PhantomJS"

# general
# RUN apt-get clean
# RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# RUN apt-get update
# RUN apt-get install gcc g++ make curl zlib1g zlib1g-dev vim openssl libcurl4-openssl-dev libreadline6-dev unzip libffi-dev -y --force-yes
# RUN apt-get install libssl-dev libpcrecpp0 libpcre3-dev wget git libreadline-dev libqtwebkit-dev xvfb imagemagick -y --force-yes
# RUN apt-get install libsasl2-2 libsasl2-dev libpq-dev -y --force-yes
# RUN mkdir /root/src

# phantomjs
# Install phantomjs. See http://phantomjs.org/download.html
ENV PHANTOMJS_NAME="phantomjs-2.1.1-linux-x86_64"
RUN apt-get update -qq && apt-get install -y curl libfontconfig > /dev/null
RUN cd /tmp && curl -s -o phantomjs.tar.bz2 -L https://bitbucket.org/ariya/phantomjs/downloads/${PHANTOMJS_NAME}.tar.bz2 && \
    tar xvjf phantomjs.tar.bz2 && mv ${PHANTOMJS_NAME}/bin/phantomjs /usr/local/bin && \
    rm -rf ${PHANTOMJS_NAME} phantomjs.tar.bz2

EXPOSE 8910
CMD ["phantomjs", "--webdriver=8910"]

# firefox
RUN apt-get update && apt-get install firefox -y --force-yes --fix-missing
RUN echo "DISPLAY=:99.0" | tee -a /etc/environment

# node
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN npm install -g bower

# postgres
RUN apt-get update && apt-get install -y --no-install-recommends postgresql-client && rm -rf /var/lib/apt/lists/*
