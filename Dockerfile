FROM openresty/openresty:alpine

MAINTAINER junwei he "hejunweimake@gmail.com"

COPY . /app
COPY ./docker/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

WORKDIR /app

EXPOSE 80
