FROM nginx:latest AS build-env
RUN rm /etc/nginx/conf.d/default.conf
COPY config/nginx.config /etc/nginx/conf.d/default.conf
COPY content /usr/share/nginx/html
EXPOSE 80