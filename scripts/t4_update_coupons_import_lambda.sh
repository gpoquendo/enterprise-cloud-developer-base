#!/bin/bash

cd lambda/coupons_import

rm -f ../../coupons_import.zip

zip -r ../../coupons_import.zip index.js node_modules

cd ../../

# Update the Lambda function `coupons_import` with new code (replace zip path as needed)
awslocal lambda update-function-code \
    --function-name coupons_import \
    --zip-file fileb://coupons_import.zip

echo "Lambda function coupons_import updated successfully."