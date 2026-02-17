#!/bin/bash

# Copy .env if not exists
if [ ! -f .env ]; then
    echo "Copying .env.example to .env..."
    cp .env.example .env
fi

# Ensure uploads directory exists
mkdir -p public/uploads

# Set permissions (host side)
# We set 777 because we are mounting the volume, so container user (www-data) needs access
chmod -R 777 public/uploads

# Stop and remove containers/volumes
docker-compose down -v

# Build and start
docker-compose up -d --build

echo "Deployment complete. Website is running at http://localhost:6063"
