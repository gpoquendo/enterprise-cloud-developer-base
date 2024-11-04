#!/bin/bash

FUNCTION_NAME="coupons_list"
ROLE_ARN="arn:aws:iam::000000000000:role/coupons_production_role"
ZIP_FILE="coupons_list.zip"
API_BASE_URL="http://localhost:4566"

# Check if the Lambda function exists
echo "Checking if the Lambda function $FUNCTION_NAME exists..."
awslocal lambda get-function --function-name "$FUNCTION_NAME" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Lambda function $FUNCTION_NAME does not exist. Creating it..."
  awslocal lambda create-function \
    --function-name "$FUNCTION_NAME" \
    --runtime "nodejs14.x" \
    --zip-file fileb://$ZIP_FILE \
    --handler "index.handler" \
    --role "$ROLE_ARN"
  [ $? == 0 ] || echo "Failed to create Lambda function"
else
  echo "Lambda function $FUNCTION_NAME exists."
fi

echo "Lambda function provisioned successfully."