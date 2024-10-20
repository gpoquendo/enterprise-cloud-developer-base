#!/bin/bash

# Navigate to the project root
cd "$(dirname "$0")/.."

# Create a temporary directory for packaging
mkdir -p temp_package

# Copy the Lambda function code
cp lambda/coupons_get_token/index.js temp_package/

# Create a package.json file
cat << EOF > temp_package/package.json
{
  "dependencies": {
    "bcryptjs": "^2.4.3",
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
zip -r coupons_get_token.zip temp_package/*

# Check if the ZIP file was created
if [ ! -f coupons_get_token.zip ]; then
    echo "Failed to create the ZIP file."
    exit 1
fi

# Update Lambda function code
if ! awslocal lambda update-function-code \
    --function-name coupons_get_token \
    --zip-file fileb://coupons_get_token.zip; then
    echo "Failed to update Lambda function code."
    exit 1
fi

# Wait for the update to complete
sleep 30

# Retry mechanism for updating function configuration
for i in {1..5}; do
    if awslocal lambda update-function-configuration \
        --function-name coupons_get_token \
        --handler index.handler \
        --runtime nodejs14.x \
        --timeout 10 \
        --memory-size 128; then
        break
    else
        sleep 10
    fi
done

# Clean up
rm -rf temp_package coupons_get_token.zip

echo "coupons_get_token Lambda function updated successfully"