#!/bin/bash

# Navigate to the coupons_notification_sender lambda directory
cd lambda/coupons_notification_sender

# Remove any existing zip file
rm -f ../../coupons_notification_sender.zip

# Create a new zip file including the index.js and node_modules
zip -r ../../coupons_notification_sender.zip index.js node_modules

# Navigate back to the root directory
cd ../../

# Update the Lambda function 'coupons_notification_sender' code
awslocal lambda update-function-code \
    --function-name coupons_notification_sender \
    --zip-file fileb://coupons_notification_sender.zip

echo "Lambda function 'coupons_notification_sender' updated successfully."