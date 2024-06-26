#!/bin/bash

# Define the project directory
PROJECT_DIR="/home/shewangzawrobel/testing/COMPUTE-ENGINE-CICD-GCP"
APP_NAME="nestjs-server"

# Define environment variables
ENV_VARS="
DB_HOST=${DB_HOST}
DB_USERNAME=${DB_USER}
DB_PASSWORD=${DB_PASS}
DB_NAME=${DB_NAME}
DB_PORT=${DB_PORT}
"

# Create or update the .env file
echo "$ENV_VARS" > "$PROJECT_DIR/.env"

# Check if the directory exists
if [ -d "$PROJECT_DIR" ]; then
  echo "Directory exists. Pulling latest changes."
  cd "$PROJECT_DIR"
  git pull origin main
else
  echo "Directory does not exist. Cloning repository."
  git clone https://github.com/Robel-shewan/COMPUTE-ENGINE-CICD-GCP.git "$PROJECT_DIR"
  cd "$PROJECT_DIR"
fi

# Install npm dependencies
npm install


# Check if the application is already managed by PM2
if pm2 describe "$APP_NAME" > /dev/null; then
  echo "Application is already managed by PM2. Restarting it."
  pm2 restart "$APP_NAME"

else
  echo "Application is not managed by PM2. Starting it for the first time."
  pm2 start dist/main.js --name "$APP_NAME"

fi


# Save the PM2 process list and corresponding environments
pm2 save --force
