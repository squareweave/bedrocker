FROM wordpress:4-apache

ENV BEDROCK_VERSION=1.6.2 \
    BEDROCK_SHA1=2f7dc9670855458f78349b5dd7f1eb98ac360fe8 \
    WP_CLI_VERSION=0.23.1 \
    WP_CLI_SHA1=359b41d7cabd4f1a6ea83400b6a337443e6e7331 \
    COMPOSER_SETUP_SHA384=070854512ef404f16bac87071a6db9fd9721da1684cd4589b1196c3faf71b9a2682e2311b36a5079825e155ac7ce150d

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    WP_ENV=production \
    DEFAULT_TIMEZONE=Australia/Melbourne

RUN set -xe && \
    apt-get -qq update && \
    apt-get -qq install \
        git \
        zlib1g-dev \
        less \
        --no-install-recommends \
        && \
    docker-php-ext-install zip && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    true

RUN set -xe && \
    curl -L https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar \
        -o /usr/local/bin/wp && \
    sha1sum /usr/local/bin/wp && \
    echo "$WP_CLI_SHA1 */usr/local/bin/wp" | sha1sum -c - && \
    chmod +x  /usr/local/bin/wp && \
    curl -sS -o /tmp/composer-setup.php https://getcomposer.org/installer && \
    echo "$COMPOSER_SETUP_SHA384 */tmp/composer-setup.php" | shasum -c - && \
    php /tmp/composer-setup.php --install-dir=/usr/bin --filename=composer && \
    rm /tmp/composer-setup.php && \
    true

WORKDIR /app

RUN set -xe && \
    curl -o /tmp/bedrock.tar.gz -SL https://github.com/roots/bedrock/archive/${BEDROCK_VERSION}.tar.gz && \
    echo "$BEDROCK_SHA1 */tmp/bedrock.tar.gz" | sha1sum -c - && \
    tar --strip-components=1 -xzf /tmp/bedrock.tar.gz -C /app && \
    rm /tmp/bedrock.tar.gz && \
    chown -R www-data:www-data /app && \
    composer install --no-interaction && \
    composer remove \
             johnpbloch/wordpress \
             --no-interaction && \
    composer clear-cache && \
    mv /usr/src/wordpress /app/web/wp && \
    true

RUN set -xe && \
    { \
        echo 'date.timezone = ${DEFAULT_TIMEZONE}'; \
    } > /usr/local/etc/php/conf.d/date-timezone.ini && \
    sed -i 's#DocumentRoot.*#DocumentRoot /app/web#' /etc/apache2/apache2.conf && \
    sed -i 's#<Directory /var/www/>.*#<Directory /app/web/>#' /etc/apache2/apache2.conf && \
    mkdir -p /app/web/app/uploads && \
    true

VOLUME /app/web/app/uploads

ENTRYPOINT []
CMD ["apache2-foreground"]

RUN set -xe && \
    apt-get -qq update && \
    apt-get -qq install \
        apt-transport-https \
        --no-install-recommends && \
    curl -sL 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key' | apt-key add - && \
    echo 'deb https://deb.nodesource.com/node_5.x jessie main' > /etc/apt/sources.list.d/nodesource.list && \
    apt-get -qq update && \
    apt-get -qq install \
        nodejs \
        --no-install-recommends \
        && \
    rm /etc/apt/sources.list.d/nodesource.list && \
    apt-key del 68576280 && \
    apt-get purge -qq --auto-remove \
        -o APT::AutoRemove::RecommendsImportant=false \
        -o APT::AutoRemove::SuggestsImportant=false \
        apt-transport-https \
        && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    true