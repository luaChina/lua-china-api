FROM openresty/openresty:1.21.4.1-0-jammy

MAINTAINER junwei he "13571899655@163.com"

COPY . /app
COPY ./docker/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

WORKDIR /app

EXPOSE 80
