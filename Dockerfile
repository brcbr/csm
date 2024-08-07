# Use the official Debian base image
FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    apache2 \
    libapache2-mod-php \
    php \
    php-mysql \
    curl \
    wget \
    nano \
    tmate \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache mods
RUN a2enmod php7.4
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Copy the start.sh script to the container
COPY start.sh /usr/local/bin/start.sh

# Make the start.sh script executable
RUN chmod +x /usr/local/bin/start.sh

# Set the environment variable for PHP
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
