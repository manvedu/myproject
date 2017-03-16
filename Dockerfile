FROM ubuntu:latest
MAINTAINER mariavelandia@fluvip.com

RUN apt-get update -y

RUN apt-get install -y curl
RUN apt-get install -y git-core
RUN apt-get install -y ruby-dev zlib1g-dev liblzma-dev
RUN apt-get install -y openssl zlib1g zlib1g-dev libyaml-dev libxslt-dev autoconf libc6-dev automake libtool bison \
 libcurl4-openssl-dev \
 libffi-dev libssl-dev \
 libxml2-dev \
 imagemagick libmagickwand-dev \
 gcc \
 libpq-dev \
 wget

RUN apt-get install -y libreadline-dev
RUN apt-get install -y vim
RUN apt-get install -y libsqlite3-dev
RUN apt-get install -y nodejs
COPY ./.ssh /root/.ssh/

RUN cd /tmp && \
    wget https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.3.tar.gz && \
    tar zxfv ruby-2.3.3.tar.gz && \
    cd ruby-2.3.3 && \
    ./configure && make && make install && \
    cd .. && rm -fr ruby*

RUN gem install bundler
RUN mkdir /myproject
WORKDIR /myproject
RUN bundle config --global silence_root_warning 1
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y google-chrome-stable && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install -y unzip xvfb
RUN wget -N http://chromedriver.storage.googleapis.com/2.16/chromedriver_linux64.zip && \
  unzip chromedriver_linux64.zip && \
  chmod +x ./chromedriver && \
  cp ./chromedriver /usr/local/share/ && \
  ln -s /usr/local/share/chromedriver /usr/bin/chromedriver && \
  rm ./chromedriver*

COPY ./start-bundle-exec.sh /myproject/
ENTRYPOINT ["./start-bundle-exec.sh"]
