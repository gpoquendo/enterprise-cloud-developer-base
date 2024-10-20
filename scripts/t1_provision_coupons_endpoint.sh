#!/bin/bash

API_NAME="coupons"
API_ID=$(awslocal apigateway get-rest-apis | jq -r --arg name "$API_NAME" '.items[] | select(.name == $name) | .id')
STAGE="local"
REGION="us-east-1"
FUNCTION_NAME="coupons_list"
ENDPOINT="/coupons_poc"

if [ -z "$API_ID" ]; then
  echo "API Gateway $API_NAME not found. Please run the bootstrap script."
  exit 1
else
  echo "API Gateway $API_NAME found with ID: $API_ID"
fi

# Create resource for the endpoint if it doesn't exist
PARENT_ID=$(awslocal apigateway get-resources --rest-api-id "$API_ID" | jq -r '.items[] | select(.path == "/") | .id')
RESOURCE_ID=$(awslocal apigateway get-resources --rest-api-id "$API_ID" | jq -r --arg path "$ENDPOINT" '.items[] | select(.path == $path) | .id')

if [ -z "$RESOURCE_ID" ]; then
  echo "Creating resource for $ENDPOINT..."
  RESOURCE_ID=$(awslocal apigateway create-resource --rest-api-id "$API_ID" --parent-id "$PARENT_ID" --path-part "coupons_poc" | jq -r '.id')
else
  echo "Resource for $ENDPOINT already exists."
fi

# Create GET method for the resource
echo "Creating GET method for $ENDPOINT..."
awslocal apigateway put-method --rest-api-id "$API_ID" --resource-id "$RESOURCE_ID" --http-method GET --authorization-type "NONE"

# Set the Lambda function as the integration
echo "Integrating Lambda function $FUNCTION_NAME with the GET method..."
awslocal apigateway put-integration --rest-api-id "$API_ID" --resource-id "$RESOURCE_ID" --http-method GET \
  --type AWS_PROXY --integration-http-method POST \
  --uri arn:aws:apigateway:$REGION:lambda:path/2015-03-31/functions/arn:aws:lambda:$REGION:000000000000:function:$FUNCTION_NAME/invocations

# Deploy the API
echo "Deploying API to stage $STAGE..."
awslocal apigateway create-deployment --rest-api-id "$API_ID" --stage-name "$STAGE"

echo "API Gateway endpoint provisioned successfully."
