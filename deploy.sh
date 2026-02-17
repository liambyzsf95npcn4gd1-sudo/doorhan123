#!/bin/bash
set -e

echo "Deploying DoorHan Application..."

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

echo "Setting permissions..."
chmod -R 755 .
chmod -R 777 public/uploads

echo "Building and starting Docker containers..."
docker-compose down
docker-compose up -d --build

echo "Waiting for database to be ready..."
until docker-compose exec -T db mysqladmin ping -h "localhost" --silent; do
    echo "Waiting for database connection..."
    sleep 2
done

echo "Deployment complete! Application running at http://localhost:8080"
