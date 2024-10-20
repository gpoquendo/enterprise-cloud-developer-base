#!/bin/bash

# Add a policy to the SNS topic to restrict the usage to 'email' protocol
TOPIC_ARN=$(awslocal sns list-topics | grep -o 'arn:aws:sns:[^"]*coupons')

awslocal sns set-topic-attributes \
    --topic-arn $TOPIC_ARN \
    --attribute-name Policy \
    --attribute-value '{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": "*",
          "Action": "SNS:Publish",
          "Resource": "'"$TOPIC_ARN"'",
          "Condition": {
            "StringEquals": {
              "SNS:Protocol": "email"
            }
          }
        }
      ]
    }'

echo "Policy added to SNS topic 'coupons' to restrict the protocol to 'email'."