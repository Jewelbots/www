FROM ubuntu:14.04
MAINTAINER George Stocker <george@jewliebots.com>
RUN sudo apt-get update && apt-get install -y \
  dialog \ 
  nano \
  net-tools \
  nginx \
  wget
RUN rm -v /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
EXPOSE 80
ADD /www/ /var/src/www/
CMD service nginx start
