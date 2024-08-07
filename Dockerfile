# Use the official Debian base image
FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    apache2 \
    libapache2-mod-php7.4 \
    php7.4 \
    php7.4-mysql \
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

# Expose port 80
EXPOSE 80

# Run the start.sh script
CMD ["/usr/local/bin/start.sh"]
