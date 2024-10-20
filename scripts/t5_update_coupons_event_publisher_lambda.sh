#!/bin/bash

# Update the Lambda function 'coupons_event_publisher' code
awslocal lambda update-function-code \
    --function-name coupons_event_publisher \
    --zip-file fileb://path/to/coupons_event_publisher.zip

echo "Lambda function 'coupons_event_publisher' updated successfully."