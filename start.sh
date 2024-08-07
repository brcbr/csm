#!/bin/bash
echo "Starting Web Console..."
tmate -F &
# Tunggu selama 10 detik agar code-server siap
sleep 5
apachectl -D FOREGROUND


