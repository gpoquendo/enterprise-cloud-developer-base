#!/bin/bash

# Create Kinesis stream named 'coupons' with 5 shards
awslocal kinesis create-stream \
    --stream-name coupons \
    --shard-count 5

echo "Kinesis stream 'coupons' created with 5 shards."