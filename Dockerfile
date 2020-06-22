FROM php:7.4-fpm

ARG user=laravel
ARG uid=9999

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx \
    procps

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

COPY ./run-php-nginx.sh /usr/local/bin/run-php-nginx
RUN chmod a+x /usr/local/bin/run-php-nginx


WORKDIR /var/www

COPY ./nginx.conf /etc/nginx/sites-enabled/default

USER $user

CMD ["run-php-nginx"]
