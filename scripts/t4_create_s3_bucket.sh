#!/bin/bash

# Create S3 bucket using s3api
awslocal s3api create-bucket --bucket coupons --acl private