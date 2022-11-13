FROM ubuntu:18.04

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

RUN apt upgrade -y && apt-get update -y && apt-get install nginx -y

RUN echo "/ndaemon off;" >> /etc/nginx/nginx.conf

CMD ["nginx"]

EXPOSE 80
