#!/bin/bash

# Update the Lambda function 'coupons_notification_sender' code
awslocal lambda update-function-code \
    --function-name coupons_notification_sender \
    --zip-file fileb://path/to/coupons_notification_sender.zip

echo "Lambda function 'coupons_notification_sender' updated successfully."