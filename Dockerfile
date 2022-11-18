FROM nginx

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

RUN apt upgrade -y && apt-get update -y

COPY app/time.html /usr/share/nginx/html

EXPOSE 80
