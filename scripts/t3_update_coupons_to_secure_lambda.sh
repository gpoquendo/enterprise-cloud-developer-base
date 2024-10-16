#!/bin/bash

# Navigate to the coupons_get_token lambda directory
cd lambda/coupons_to_secure

# Remove any existing zip file
rm -f ../../coupons_to_secure.zip

# Create a new zip file including the index.js and node_modules
zip -r ../../coupons_to_secure.zip index.js node_modules

# Navigate back to the root directory
cd ../../

# Update the Lambda function with the new code
awslocal lambda update-function-code \
  --function-name coupons_to_secure \
  --zip-file fileb://coupons_to_secure.zip

echo "Lambda function updated successfully."
