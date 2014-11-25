FROM debian:wheezy
MAINTAINER Gil Gyeong-Min "rushcut@gmail.com"

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.7.7-1~wheezy

RUN apt-get update && apt-get install -y nginx=${NGINX_VERSION}

ADD conf/nginx.conf /etc/nginx/nginx-conf/nginx.conf

RUN mkdir -p /etc/nginx/nginx-conf
RUN mkdir -p /etc/nginx/sites-enabled

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]
VOLUME ["/etc/nginx/certs", "/etc/nginx/sites-enabled", "/var/log/nginx", "/etc/nginx/nginx-conf"]

EXPOSE 80 443

CMD ["nginx", "-c", "nginx-conf/nginx.conf", "-g", "daemon off;"]
