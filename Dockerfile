# Use Ubuntu as the base image
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Update and install basic packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    wget git curl sudo tmate nano python3 python3-venv python3-pip dbus-x11 php \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a new user and set up the environment
RUN useradd -m coder \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /home/coder/project

# Select Python version and install python3-venv if the detected version is available
RUN PYTHON_VERSIONS=$(ls /usr/bin/python3.9 /usr/bin/python3.11 2>/dev/null | grep -Eo 'python3\.[0-9]+') \
    && if echo "$PYTHON_VERSIONS" | grep -q "python3.11"; then \
        PYTHON_VERSION="3.11"; \
    elif echo "$PYTHON_VERSIONS" | grep -q "python3.9"; then \
        PYTHON_VERSION="3.9"; \
    else \
        echo "Desired Python version not found." \
        && exit 1; \
    fi \
    && echo "Using Python version $PYTHON_VERSION" \
    && apt-get install -y python${PYTHON_VERSION}-venv

WORKDIR /home/coder/project

# Download necessary files
RUN wget https://raw.githubusercontent.com/cihuuy/nest-web/main/index.py \
    && wget https://raw.githubusercontent.com/cihuuy/nest-web/main/nest.py \
    && wget https://raw.githubusercontent.com/cihuuy/nest-web/main/index.php \
    && wget https://raw.githubusercontent.com/cihuuy/nest-web/main/requirements.txt 

# Copy and set up the start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose port 8080
EXPOSE 8080

# Start the services
CMD ["/usr/local/bin/start.sh"]
