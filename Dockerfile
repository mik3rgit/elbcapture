FROM ubuntu:xenial

EXPOSE 80

ENV MONGODBHOST=mongodb

RUN apt-get update                                                                        && \
    apt-get -y install apache2 php php-cli libapache2-mod-php php-mongodb                 && \
    rm -f /var/www/html/index.html                                                        && \
    ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

COPY etc/apache2/sites-available /etc/apache2/sites-available
COPY var/www/html /var/www/html

CMD apache2ctl -DFOREGROUND

