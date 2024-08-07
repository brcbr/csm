# Use the official Debian base image
FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt-get update && apt-get install -y \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    wget \
    curl \
    gnupg2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add the Sury repository for PHP 7.4
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Update and install necessary packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    apache2 \
    libapache2-mod-php7.4 \
    php7.4 \
    php7.4-mysql \
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
COPY apchconfig.conf /etc/apache2/conf-available/apchconfig.conf
RUN a2enconf apchconfig
# Copy the start.sh script to the container
COPY start.sh /usr/local/bin/start.sh

# Make the start.sh script executable
RUN chmod +x /usr/local/bin/start.sh

# Expose port 80
EXPOSE 80

# Run the start.sh script
CMD ["/usr/local/bin/start.sh"]
