#!/bin/bash

# Navigate to the coupons_event_publisher lambda directory
cd lambda/coupons_event_publisher

# Remove any existing zip file
rm -f ../../coupons_event_publisher.zip

# Create a new zip file including the index.js and node_modules
zip -r ../../coupons_event_publisher.zip index.js node_modules

# Navigate back to the root directory
cd ../../

# Update the Lambda function 'coupons_event_publisher' code
awslocal lambda update-function-code \
    --function-name coupons_event_publisher \
    --zip-file fileb://coupons_event_publisher.zip

echo "Lambda function 'coupons_event_publisher' updated successfully."