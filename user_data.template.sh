#!/bin/bash

#define enviroment vars
export RAILS_MASTER_KEY={RAILS_MASTER_KEY}
export DB_HOST={DB_HOST}
export DB_PORT={DB_PORT}
export DB_USERNAME={DB_USERNAME}
export DB_PASSWORD={DB_PASSWORD}
export DB_NAME={DB_NAME}


# don't change below
echo "DB_HOST=$DB_HOST" >> /etc/environment
echo "DB_PORT=$DB_PORT" >> /etc/environment
echo "DB_USERNAME=$DB_USERNAME" >> /etc/environment
echo "DB_PASSWORD=$DB_PASSWORD" >> /etc/environment
echo "DB_NAME=$DB_NAME" >> /etc/environment

curl -fsSL https://get.docker.com -o install-docker.sh
sh install-docker.sh

usermod -aG docker ubuntu
apt install -y docker-compose

eval "$(ssh-agent -s)"
ssh-keyscan github.com >> ~/.ssh/known_hosts

cd /home/ubuntu
git clone https://github.com/mycotics/bookstore.git

docker compose -f ./bookstore/docker-compose.yaml up -d

echo "FINISHED!"
