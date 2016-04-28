# Bedrocker

Bedrocker is an integration of [Bedrock](https://github.com/roots/bedrock) and [Docker](http://www.docker.com).
It makes use of the existing official [WordPress image](http://hub.docker.com/_/wordpress/) and therefore automatically
gets WP updates.

## Using this image

To implement your installation using this image, create your own Dockerfile using this as the base image, like so:

    FROM squareweave/bedrocker

The project installs Bedrock into `/app`, and sets the Apache webroot to be `/app/web`. WordPress is installed (as you would expect) to `/app/web/wp`.

wp-cli is installed as the command `wp`, and you can run this by `docker exec -ti [name of your container] wp`. Composer is installed as `composer`, and you can run that in a similar fashion.

Example of using composer in your build:

    FROM squareweave/bedrocker

    COPY composer.json composer.lock /app/
    RUN composer install && composer clear-cache


To add themes, plugins, etc, all you need to do is `COPY` those into your project. An easy way to do this is to have an `app` directory in your project which is copied into the /app

Example of copying app/themes to your container during build:

    FROM squareweave/bedrocker

    COPY app/themes /app/web/app/themes
