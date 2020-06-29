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
    chown -R $user:$user /home/$user /var/lib/nginx /var/log/nginx

RUN sed -i -e 's/user\swww-data;/ /g' /etc/nginx/nginx.conf
RUN sed -i -e 's/error_log[^\;]*/error_log \/dev\/stderr/g' /etc/nginx/nginx.conf
RUN sed -i -e 's/pid[^\;]*/pid \/var\/lib\/nginx\/nginx.pid/g' /etc/nginx/nginx.conf

COPY ./run-php-nginx.sh /usr/local/bin/run-php-nginx
RUN chmod a+x /usr/local/bin/run-php-nginx

WORKDIR /var/www

COPY ./nginx.conf /etc/nginx/sites-enabled/default

EXPOSE 8080

CMD ["run-php-nginx"]
