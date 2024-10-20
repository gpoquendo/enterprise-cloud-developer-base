#!/bin/bash

cd lambda/coupons_import_presigned_url

rm -f ../../coupons_import_presigned_url.zip

# Define variables
FUNCTION_NAME="coupons_import_presigned_url"
BUCKET_NAME="coupons"
API_NAME="coupons_api"
RESOURCE_PATH="import_presigned_url"
ZIP_FILE="${FUNCTION_NAME}.zip"

zip -r ../../coupons_import_presigned_url.zip index.js node_modules

cd ../../

# Update the Lambda function `coupons_import_presigned_url` with new code
awslocal lambda update-function-code \
    --function-name $FUNCTION_NAME \
    --zip-file fileb://$ZIP_FILE

echo "Lambda function coupons_import_presigned_url updated successfully."


# Step 3: Create API Gateway REST API if not already created
rest_api_id=$(awslocal apigateway get-rest-apis --query "items[?name==\`$API_NAME\`].id" --output text)
if [ -z "$rest_api_id" ]; then
    rest_api_id=$(awslocal apigateway create-rest-api --name $API_NAME --query 'id' --output text)
    echo "API Gateway $API_NAME created."
else
    echo "Using existing API Gateway: $API_NAME."
fi

# Step 4: Get the root resource id of the API
root_resource_id=$(awslocal apigateway get-resources --rest-api-id "$rest_api_id" --query "items[?path==\`/\`].id" --output text)

# Step 5: Create the resource for /coupons/import_presigned_url
resource_id=$(awslocal apigateway create-resource \
    --rest-api-id "$rest_api_id" \
    --parent-id "$root_resource_id" \
    --path-part $RESOURCE_PATH \
    --query 'id' --output text)

# Step 6: Create the POST method for the /coupons/import_presigned_url resource
awslocal apigateway put-method \
    --rest-api-id "$rest_api_id" \
    --resource-id "$resource_id" \
    --http-method POST \
    --authorization-type NONE

# Step 7: Set up Lambda integration for the POST method
awslocal apigateway put-integration \
    --rest-api-id "$rest_api_id" \
    --resource-id "$resource_id" \
    --http-method POST \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:$FUNCTION_NAME/invocations

# Step 8: Deploy the API
awslocal apigateway create-deployment \
    --rest-api-id "$rest_api_id" \
    --stage-name dev

echo "API Gateway endpoint for /coupons/$RESOURCE_PATH created and integrated with the $FUNCTION_NAME Lambda function."