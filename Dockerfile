########################################### node ######################################################################
FROM node:8.15 as node

RUN apt-get update &&\
    apt-get install -y unzip &&\
    rm -rf /var/lib/apt/lists/*

# install chromedriver
WORKDIR /tmp
RUN wget -qnv https://chromedriver.storage.googleapis.com/LATEST_RELEASE -O - | wget -q "https://chromedriver.storage.googleapis.com/`cat`/chromedriver_linux64.zip" && \
  unzip chromedriver_linux64.zip && \
  chmod +x chromedriver && \
mv chromedriver /usr/bin/

#######################################################################################################################
FROM ruby:2.5.3

RUN mkdir -p /var/log/supervisor

# install chrome
WORKDIR /tmp
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
  apt-get update && \
  apt-get install -y google-chrome-stable

COPY --from=node /usr/bin/chromedriver /usr/bin/
COPY --from=node /usr/local/bin/node /usr/local/bin/

ENV RUBYOPT -EUTF-8
ENV LANG ja_JP.UTF-8
RUN apt-get update &&\
    apt-get install -y mysql-client imagemagick jpegoptim optipng graphviz fonts-ipafont cron supervisor vim --no-install-recommends &&\
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN gem install bundler
RUN curl -0 -L http://npmjs.org/install.sh | sh
