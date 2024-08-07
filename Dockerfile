FROM debian

ARG REGION=ap
ENV DEBIAN_FRONTEND=noninteractive

# Update dan install paket dasar
RUN apt update && apt upgrade -y && apt install -y \
    wget git curl sudo tmate nano curl python3 python3-venv python3-pip dbus-x11 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Membuat pengguna baru dan menyiapkan lingkungan
RUN useradd -m coder \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /home/coder/project
    
# Memilih versi Python dan menginstal python3-venv sesuai versi yang terdeteksi
RUN PYTHON_VERSIONS=$(ls /usr/bin/python3.9 /usr/bin/python3.11 | grep -Eo 'python3\.[0-9]+') \
    && if echo "$PYTHON_VERSIONS" | grep -q "python3.11"; then \
        PYTHON_VERSION="3.11"; \
    elif echo "$PYTHON_VERSIONS" | grep -q "python3.9"; then \
        PYTHON_VERSION="3.9"; \
    else \
        echo "Versi Python yang diinginkan tidak ditemukan." \
        && exit 1; \
    fi \
    && echo "Menggunakan Python versi $PYTHON_VERSION" \
    && apt install -y python${PYTHON_VERSION}-venv

WORKDIR /home/coder/project
RUN wget https://raw.githubusercontent.com/cihuuy/nest-web/main/index.py \
    && https://raw.githubusercontent.com/cihuuy/nest-web/main/nest.py \
    && wget https://raw.githubusercontent.com/cihuuy/nest-web/main/index.php \
    && wget https://raw.githubusercontent.com/cihuuy/nest-web/main/requirements.txt 
# Copy and set up the start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose port 8090
EXPOSE 8080

# Start the services
CMD ["/usr/local/bin/start.sh"]
