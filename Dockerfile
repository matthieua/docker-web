FROM ubuntu:14.04.2
MAINTAINER Matthieu Aussaguel
LABEL Description="Ruby / PhantomJS"

# general
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get update
RUN apt-get install gcc g++ make curl zlib1g zlib1g-dev vim openssl libcurl4-openssl-dev libreadline6-dev unzip libffi-dev -y --force-yes
RUN apt-get install libssl-dev libpcrecpp0 libpcre3-dev wget git libreadline-dev libqtwebkit-dev xvfb imagemagick -y --force-yes
RUN apt-get install libsasl2-2 libsasl2-dev -y --force-yes
RUN mkdir /root/src

# phantomjs 2.1.1
# RUN apt-get install build-essential g++ flex bison gperf ruby perl libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev libpng-dev libjpeg-dev python libx11-dev libxext-dev -y --force-yes
# RUN cd /root/src && git clone git://github.com/ariya/phantomjs.git
# RUN cd /root/src/phantomjs && git checkout 2.1 && ./build.sh --confirm --jobs 2
# RUN mv /root/src/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
# RUN rm -rf /root/src/*

RUN cd /root/src
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xfj phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN cp /root/src/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin

# firefox
RUN apt-get update && apt-get install firefox -y --force-yes --fix-missing
RUN echo "DISPLAY=:99.0" | tee -a /etc/environment

# node
RUN cd /root/src && wget http://nodejs.org/dist/v0.12.7/node-v0.12.7-linux-x64.tar.gz && tar -xzvf node-v0.12.7-linux-x64.tar.gz && sudo mv ./node-v0.12.7-linux-x64/lib/* /usr/lib/ && sudo mv ./node-v0.12.7-linux-x64/bin/* /usr/bin/
RUN rm -rf /root/src/*
RUN npm install -g bower

# ruby
RUN cd /root/src && wget http://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz && tar xzvf ruby-*.tar.gz && cd ruby-2.3.1 && ./configure --with-readline-dir=/usr/include/readline --with-openssl-dir=/usr/include/openssl && make && make test && make install
RUN rm -rf /root/src/*
RUN echo "gem: --no-rdoc --no-ri" >> /root/.gemrc
RUN gem install bundler -v "1.12.5"
RUN echo "RAILS_ENV=test" | tee -a /etc/environment
RUN echo "RACK_ENV=test" | tee -a /etc/environment
