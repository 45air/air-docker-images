FROM php:7.1-fpm

RUN apt-get update \
	&& apt-get install -y \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
	libz-dev \
	less \
	mariadb-client \
	libmemcached11 \
	libmemcachedutil2 \
	libmemcached-dev \
	git \
	subversion \
	wget \
	libxml2-dev \
	imagemagick \
	libmagickwand-dev \
	unzip \
	iproute2 \
	libicu-dev \
	msmtp \
	msmtp-mta \
	&& docker-php-ext-install -j$(nproc) \
	mysqli \
	pdo_mysql \
	sockets \
	zip \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install soap intl \
	&& pecl install xdebug memcached imagick \
	&& docker-php-ext-enable xdebug memcached imagick \
	&& apt-get remove -y build-essential libz-dev libmemcached-dev libmagickwand-dev libxml2-dev libicu-dev \
	&& apt-get autoremove -y \
	&& apt-get clean

RUN curl https://getcomposer.org/download/$(curl -LSs https://api.github.com/repos/composer/composer/releases/latest | grep 'tag_name' | sed -e 's/.*: "//;s/".*//')/composer.phar > composer.phar \
	&& chmod +x composer.phar \
	&& mv composer.phar /usr/local/bin/composer

RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp \
	&& mkdir /var/www/.wp-cli \
	&& chown www-data:www-data /var/www/.wp-cli

RUN curl -L https://phar.phpunit.de/phpunit.phar > /tmp/phpunit.phar \
	&& chmod +x /tmp/phpunit.phar \
	&& mv /tmp/phpunit.phar /usr/local/bin/phpunit

COPY msmtp.conf /root/.msmtprc

RUN XDEBUG=$(find /usr/local/lib/php -name 'xdebug.so' | head -n 1 | tail -n 1) \
	&& ln -s $XDEBUG /usr/local/lib/php/extensions/xdebug.so \
	&& rm /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh \
	&& mv /var/www/html /var/www/web \
	&& chown www-data:www-data /var/www/web

WORKDIR /var/www/web

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]

EXPOSE 9000
