FROM ruby:2.3.1

RUN mkdir -p /var/log/supervisor

RUN apt-get update && \
  apt-get install -y mysql-client imagemagick jpegoptim optipng fonts-ipafont cron supervisor unzip --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

# install chrome
WORKDIR /tmp
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
  apt-get update && \
  apt-get install -y google-chrome-stable

# install chromedriver
WORKDIR /tmp
RUN wget -qnv https://chromedriver.storage.googleapis.com/LATEST_RELEASE -O - | wget -q "https://chromedriver.storage.googleapis.com/`cat`/chromedriver_linux64.zip" && \
  unzip chromedriver_linux64.zip && \
  chmod +x chromedriver && \
  mv chromedriver /usr/bin/
