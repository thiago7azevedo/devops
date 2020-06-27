FROM nginx:alpine
COPY ./conf.d/default.conf /etc/nginx/conf.d
EXPOSE 80
WORKDIR /etc/nginx/conf.d
ENTRYPOINT ["/usr/sbin/nginx"]
CMD ["-g", "daemon off;"]

