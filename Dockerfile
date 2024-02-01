FROM php:8.2-fpm

WORKDIR /var/www/html

COPY --chown=www-data:www-data . /var/www/html

RUN apt-get update -y && apt-get install -y curl zip unzip sendmail libpng-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libonig-dev \
        default-mysql-client \
        net-tools \
        inetutils-ping \
        && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
        && docker-php-ext-install gd

RUN apt-get install -y git
RUN apt-get install -y zip libzip-dev libicu-dev \
  && docker-php-ext-configure zip \
  && docker-php-ext-install zip \
  && docker-php-ext-configure intl \
  && docker-php-ext-install intl \
  && docker-php-ext-install exif && docker-php-ext-enable exif

RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-enable mysqli pdo pdo_mysql
RUN docker-php-ext-install pcntl bcmath sockets

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

##################
# Custom Aliases #
##################

# Small hack for me to simplify chmod command needed on adding new files from within the container
# to prevent Permission Denied Issues
RUN echo "alias chp='chmod -R 0777 app/ database/ storage/ config/ resources/ tests/'" >> ~/.bashrc
RUN echo "alias autoload='composer dumpautoload'" >> ~/.bashrc
RUN echo "alias art='php artisan'" >> ~/.bashrc
RUN echo "alias tinker='php artisan tinker'" >> ~/.bashrc
RUN echo "alias optimize='php artisan optimize'" >> ~/.bashrc
RUN echo "alias schema='php artisan schema:dump'" >> ~/.bashrc
RUN echo "alias dump='php artisan db:dump'" >> ~/.bashrc
RUN echo "alias migrate='php artisan migrate'" >> ~/.bashrc
RUN echo "alias smigrate='php artisan migrate --seed'" >> ~/.bashrc
RUN echo "alias seed='php artisan db:seed'" >> ~/.bashrc
RUN echo "alias fresh='php artisan migrate:fresh'" >> ~/.bashrc
RUN echo "alias freshs='php artisan migrate:fresh --seed'" >> ~/.bashrc
RUN echo "alias rmschema='rm -f database/schema/mysql-schema.sql'" >> ~/.bashrc
RUN echo "alias pint='./vendor/bin/pint'" >> ~/.bashrc
RUN echo "alias pest='./vendor/bin/pest'" >> ~/.bashrc
RUN echo "alias prepush='pint && stan && pest && composer update --prefer-stable'" >> ~/.bashrc
