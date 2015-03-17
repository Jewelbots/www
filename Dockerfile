FROM ubuntu 14.04
MAINTAINER George Stocker <george@jewliebots.com>
RUN echo "deb http://archive.ubuntu.com/ubunto/ raring main universe" >> /etc/apt/sources.list
RUN sudo apt-get update
RUN apt-get install -y nano wget dialog net-tools
RUN apt-get install -y nginx
RUN rm -v /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
EXPOSE 80
ADD /www/ /var/src/www/
CMD service nginx start
