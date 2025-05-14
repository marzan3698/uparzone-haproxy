#!/bin/bash

echo "Starting HAProxy and Redis containers..."

git pull

cd uparzone-haproxy/ || exit

if [ ! -f .env ]; then
    cp .env.example .env
    REDIS_PASSWORD=$(openssl rand -base64 32)
    if grep -q "^REDIS_PASSWORD=" .env; then
        sed -i "/^REDIS_PASSWORD=/c\REDIS_PASSWORD=$REDIS_PASSWORD" .env
    else
        echo "REDIS_PASSWORD=$REDIS_PASSWORD" >> .env
    fi
    echo "=========="
    echo "REDIS_PASSWORD is set to $REDIS_PASSWORD"
    echo "=========="
fi

if [ ! -f haproxy.cfg ]; then
    cp haproxy.cfg.example haproxy.cfg
fi

docker system prune --all -a -f

docker-compose up -d

WORKING_DIR=$(pwd)
echo ""
echo "Update HAProxy Config in $WORKING_DIR/haproxy.cfg and restart container to apply changes."
echo ""
echo "Set the SSL Certificate in $WORKING_DIR/certs/uparzone.com.pem. The crt option should point to a combined certificate file that includes both the certificate and the private key in a single .pem file."
