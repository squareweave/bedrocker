FROM wordpress:4-apache

# Version control of Bedrock
ENV BEDROCK_VERSION 1.6.2
ENV BEDROCK_SHA1 2f7dc9670855458f78349b5dd7f1eb98ac360fe8

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    WP_ENV=production \
    DEFAULT_TIMEZONE=Australia/Melbourne

RUN set -xe && \
    apt-get -qq update && \
    apt-get -qq install \
        git \
        zlib1g-dev \
        --no-install-recommends \
        && \
    docker-php-ext-install zip && \
    rm -r /var/lib/apt/lists/*

RUN set -xe && \
    curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        -o /usr/local/bin/wp && \
    chmod +x  /usr/local/bin/wp && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    true

WORKDIR /app

RUN set -xe && \
    curl -o /tmp/bedrock.tar.gz -SL https://github.com/roots/bedrock/archive/${BEDROCK_VERSION}.tar.gz && \
    echo "$BEDROCK_SHA1 */tmp/bedrock.tar.gz" | sha1sum -c - && \
    tar --strip-components=1 -xzf /tmp/bedrock.tar.gz -C /app && \
    rm /tmp/bedrock.tar.gz && \
    chown -R www-data:www-data /app && \
    ln -s /usr/src/wordpress /app/web/wp && \
    true

RUN { \
        echo 'date.timezone = ${DEFAULT_TIMEZONE}'; \
    } > /usr/local/etc/php/conf.d/date-timezone.ini && \
    sed -i 's#DocumentRoot.*#DocumentRoot /app/web#' /etc/apache2/apache2.conf && \
    sed -i 's#<Directory /var/www/>.*#<Directory /app/web/>#' /etc/apache2/apache2.conf && \
    true

VOLUME [/app/web/app/uploads]

ENTRYPOINT []
CMD ["apache2-foreground"]