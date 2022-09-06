FROM nginx:latest AS build-env
RUN rm /etc/nginx/conf.d/default.conf
COPY config/nginx.config /etc/nginx/conf.d/default.conf
EXPOSE 80