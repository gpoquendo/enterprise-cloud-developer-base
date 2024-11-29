#!/bin/bash

# Navigate to the project root
cd "$(dirname "$0")/.."

# Create a temporary directory for packaging
mkdir -p temp_package

# Copy the Lambda function code
cp lambda/coupons_to_secure/index.js temp_package/

# Create a package.json file
cat << EOF > temp_package/package.json
{
  "dependencies": {
    "jsonwebtoken": "^8.5.1"
  }
}
EOF

# Install dependencies
cd temp_package
if ! npm install --production; then
    echo "Failed to install dependencies."
    exit 1
fi
cd ..

# Create the deployment package
zip -r coupons_to_secure.zip temp_package/*

# Check if the ZIP file was created
if [ ! -f coupons_to_secure.zip ]; then
    echo "Failed to create the ZIP file."
    exit 1
fi

# Update Lambda function code
if ! awslocal lambda update-function-code \
    --function-name coupons_to_secure \
    --zip-file fileb://coupons_to_secure.zip; then
    echo "Failed to update Lambda function code."
    exit 1
fi

# Wait for the update to complete
sleep 30

# Update Lambda function configuration
if ! awslocal lambda update-function-configuration \
    --function-name coupons_to_secure \
    --handler index.handler \
    --runtime nodejs14.x \
    --timeout 10 \
    --memory-size 128; then
    echo "Failed to update Lambda function configuration."
    exit 1
fi

# Clean up
rm -rf temp_package coupons_to_secure.zip

echo "coupons_to_secure Lambda function updated successfully"