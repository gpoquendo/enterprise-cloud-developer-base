#!/bin/bash

# Define the bucket policy to prevent deletions without MFA
cat <<EOT > bucket-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "s3:DeleteObject",
      "Resource": "arn:aws:s3:::coupons/*",
      "Condition": {
        "StringNotEquals": {
          "aws:MultiFactorAuthPresent": "true"
        }
      },
      "Principal": "*"
    }
  ]
}
EOT

# Apply the bucket policy to the 'coupons' bucket
awslocal s3api put-bucket-policy --bucket coupons --policy file://bucket-policy.json

# Clean up the policy file
rm bucket-policy.json