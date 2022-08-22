FROM php:8.0-fpm-alpine3.16

# Essentials
RUN echo "UTC" > /etc/timezone
RUN apk add --no-cache zip unzip openrc curl nano sqlite nginx supervisor

# Add Dependencies
RUN apk update && apk add --no-cache \
    php8-mbstring \
    php8-fpm \
    php8-mysqli \
    php8-opcache \
    # php8-pecl-redis \
    php8-phar \
    php8-xml \
    php8-xmlreader \
    php8-zip \
    php8-zlib \
    php8-pdo \
    php8-xmlwriter \
    php8-tokenizer \
    php8-session \
    php8-pdo_mysql \
    php8-pdo_sqlite \
    nginx \
    supervisor \
    curl \
    mysql-client \
    dcron

# Install modules
RUN php -m


# Add Composer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="./vendor/bin:$PATH"

# Setup document root
RUN mkdir -p /var/www/html
RUN mkdir -p /etc/supervisor

# PHP Error Log Files
RUN mkdir /var/log/php
RUN touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log

# Setup Crond and Supervisor by default
RUN echo '*  *  *  *  * /usr/local/bin/php  /var/www/artisan schedule:run >> /dev/null 2>&1' > /etc/crontabs/root && mkdir /etc/supervisor.d

# Setup Working Dir
WORKDIR /var/www/html
