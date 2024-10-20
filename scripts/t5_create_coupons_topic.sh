#!/bin/bash

# Create SNS topic named 'coupons'
awslocal sns create-topic --name coupons

echo "SNS topic 'coupons' created."