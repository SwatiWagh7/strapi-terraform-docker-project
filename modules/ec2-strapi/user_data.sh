#!/bin/bash
set -xe
exec > /var/log/user-data.log 2>&1

echo "===== USER DATA START ====="

########################################
# Install Docker
########################################
yum update -y
yum install -y docker

systemctl enable docker
systemctl start docker

########################################
# Wait for Docker
########################################
until docker info >/dev/null 2>&1; do
  sleep 5
done

########################################
# Pull Strapi image from Docker Hub
########################################
docker pull swatiakshaywagh/strapi:latest

########################################
# Run Strapi container
########################################
docker run -d \
  --name strapi \
  -p 1337:1337 \
  swatiakshaywagh/strapi:latest

echo "===== USER DATA END ====="
