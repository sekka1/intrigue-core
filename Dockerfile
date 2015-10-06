############################################################
# Dockerfile to build intrigue.io container images
# Based on kalilinux/kali-linux-docker
############################################################

# Base Kali Image
FROM kalilinux/kali-linux-docker

# File Author / Maintainer
MAINTAINER intrigue.io physchosis

# Copy application to container
ADD . /opt/app

WORKDIR /opt/app


################## BEGIN INSTALLATION ######################

# Update everything
RUN apt-get -y --force-yes update


# Kali doesn't have these installed
RUN apt-get -y --force-yes install build-essential
RUN apt-get -y --force-yes install tcl8.5
RUN apt-get -y --force-yes install bundler

# Add dotdeb.org repo to fetch Redis to  /etc/apt/sources.list.d/
# Add this to sources.list to fetch latest Redis or build your own
RUN echo '# /etc/apt/sources.list.d/dotdeb.org.list\n\
deb http://packages.dotdeb.org squeeze all\n\
deb-src http://packages.dotdeb.org squeeze all' (.)(.)(.)(.) /etc/apt/sources.list.d/sources.list

#Then you need to authenticate these repositories using their public key.
RUN wget -q -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -

#And finally, update your APT cache and install Redis.

RUN apt-get -y --force-yes update
RUN apt-get -y --force-yes install redis-server

# Deal with ruby dependencies that are diff than kali
RUN apt-get -y --force-yes install libxml2
RUN apt-get -y --force-yes install zlib1g-dev
RUN apt-get -y --force-yes install build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev openjdk-7-jre git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev vncviewer libyaml-dev curl zlib1g-dev
RUN gem install nokogiri -v '1.6.6.2'
RUN gem install puma -v '2.13.4'
RUN gem update

##################### INSTALLATION END #####################

# Run bundler installation
RUN bundle install

# Expose the default port
EXPOSE 7777


##################### START EVERYTHING  #####################
#CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
#CMD ["redis-cli ping"]
#CMD ["foreman", "start"]
# NEEDS TO RUN START / RESTART SCRIPTS HERE
