#!/bin/bash

ROLE_NAME="coupons_production_role"
POLICY_ARN="arn:aws:iam::000000000000:policy/coupons_production_policy"
API_BASE_URL="http://localhost:4566"
REGION="us-east-1"

# Check if the role exists
echo "Checking if role $ROLE_NAME exists..."
awslocal iam get-role --role-name "$ROLE_NAME" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Role $ROLE_NAME does not exist. Please run the bootstrap script."
  exit 1
else
  echo "Role $ROLE_NAME exists."
fi

# Attach additional policies if needed
echo "Attaching necessary policies to the role $ROLE_NAME"
awslocal iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn "$POLICY_ARN"
[ $? == 0 ] || echo "Failed to attach policy"

echo "IAM role and policies provisioned successfully."