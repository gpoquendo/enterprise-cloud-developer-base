#!/bin/bash

# Navigate to the root directory (assuming the script is run from the scripts directory)
cd ..

# Add new index to DynamoDB table
awslocal dynamodb update-table \
    --table-name coupons \
    --attribute-definitions \
        AttributeName=provider_id,AttributeType=S \
        AttributeName=campaign_id,AttributeType=S \
    --global-secondary-index-updates \
        "[{
            \"Create\": {
                \"IndexName\": \"ProviderCampaignIndex\",
                \"KeySchema\": [
                    {\"AttributeName\":\"provider_id\",\"KeyType\":\"HASH\"},
                    {\"AttributeName\":\"campaign_id\",\"KeyType\":\"RANGE\"}
                ],
                \"Projection\": {
                    \"ProjectionType\":\"ALL\"
                },
                \"ProvisionedThroughput\": {
                    \"ReadCapacityUnits\": 5,
                    \"WriteCapacityUnits\": 5
                }
            }
        }]"

echo "Index 'ProviderCampaignIndex' added to DynamoDB table 'coupons' successfully."