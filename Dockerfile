FROM php:5.6.29-apache

MAINTAINER Franco Springveldt "franco@fswebworks.co.za"
### SET UP

RUN apt-get -qq update

RUN apt-get -qqy install sudo wget lynx telnet libmcrypt-dev nano make locales bzip2 git zip unzip \
    && docker-php-ext-install iconv mcrypt

RUN echo "LANG=en_US.UTF-8\n" > /etc/default/locale && \
	echo "en_US.UTF-8 UTF-8\n" > /etc/locale.gen && \
	locale-gen

#RUN yes | pecl install xdebug \
#	&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
#	&& echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
#	&& echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \

RUN yes | docker-php-ext-install pdo pdo_mysql mysqli

# SilverStripe Apache Configuration
RUN a2enmod rewrite && \
	echo "date.timezone = Europe/Berlin" > /etc/apache2/conf-enabled/timezone.ini && \
	echo "date.timezone = Europe/Berlin" > /usr/local/etc/php/conf.d/timezone.ini

##  - Phpunit, Composer, Phing
RUN wget https://phar.phpunit.de/phpunit-3.7.37.phar && \
	chmod +x phpunit-3.7.37.phar && \
	mv phpunit-3.7.37.phar /usr/local/bin/phpunit && \
	wget https://getcomposer.org/composer.phar && \
	chmod +x composer.phar && \
	mv composer.phar /usr/local/bin/composer && \
	pear channel-discover pear.phing.info && \
	pear install phing/phing



## Install mcrypt
#RUN add-apt-repository universe
RUN apt-get install -y php5-mcrypt php5-intl
RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

RUN php5enmod mcrypt
