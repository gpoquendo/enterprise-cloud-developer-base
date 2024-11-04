#!/bin/bash

# Navigate to the root directory (assuming the script is run from the scripts directory)
cd ..

# Check if coupons_update.zip exists, if not, create it
if [ ! -f coupons_update.zip ]; then
    echo "coupons_update.zip not found, creating it..."
    cd lambda/coupons_update
    zip -r ../../coupons_update.zip .
    cd ../..
fi

# Update Lambda function code
awslocal lambda update-function-code \
    --function-name coupons_update \
    --zip-file fileb://coupons_update.zip

echo "Lambda function 'coupons_update' updated successfully."