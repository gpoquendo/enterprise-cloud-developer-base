#!/bin/bash

# Get the SNS topic ARN for 'coupons'
TOPIC_ARN=$(awslocal sns list-topics | grep -o 'arn:aws:sns:[^"]*coupons')

# Print the TOPIC_ARN for debugging
echo "Extracted TOPIC_ARN: $TOPIC_ARN"

# Check if TOPIC_ARN is not empty
if [ -z "$TOPIC_ARN" ]; then
  echo "Error: Could not retrieve the ARN for the 'coupons' topic."
  exit 1
fi

# Define the new policy to restrict the protocol to 'email' and deny others
NEW_POLICY='{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "SNS:Publish",
            "Resource": "'"$TOPIC_ARN"'",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "'"$TOPIC_ARN"'"
                }
            }
        },
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "SNS:Publish",
            "Resource": "'"$TOPIC_ARN"'",
            "Condition": {
                "StringNotEquals": {
                    "AWS:SourceArn": "'"$TOPIC_ARN"'"
                }
            }
        }
    ]
}'

# Update the SNS topic with the new policy
awslocal sns set-topic-attributes \
    --topic-arn "$TOPIC_ARN" \
    --attribute-name Policy \
    --attribute-value "$NEW_POLICY"

echo "Policy added to restrict the protocol of SNS topic 'coupons' to 'email' only."
