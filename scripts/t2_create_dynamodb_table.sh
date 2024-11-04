#!/bin/bash

# Navigate to the root directory (assuming the script is run from the scripts directory)
cd ..

# Create DynamoDB table
awslocal dynamodb create-table \
    --table-name coupons \
    --attribute-definitions AttributeName=coupon_id,AttributeType=S \
    --key-schema AttributeName=coupon_id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=17,WriteCapacityUnits=5

echo "DynamoDB table 'coupons' created successfully."