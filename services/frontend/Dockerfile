FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY index.html /usr/share/nginx/html/index.html
COPY nginx.generated.conf /etc/nginx/conf.d/default.conf

EXPOSE 80