#!/bin/bash

# Navigate to the root directory (assuming the script is run from the scripts directory)
cd ..

# Navigate to the Lambda function directory
cd lambda/coupons_get_by_id

# Install dependencies (if any)
npm install aws-sdk

# Create a new deployment package
zip -r ../../../coupons_get_by_id.zip .

# Navigate back to the root directory
cd ../../

# Update Lambda function code
awslocal lambda update-function-code \
    --function-name coupons_get_by_id \
    --zip-file fileb://coupons_get_by_id.zip

echo "Lambda function 'coupons_get_by_id' updated successfully."