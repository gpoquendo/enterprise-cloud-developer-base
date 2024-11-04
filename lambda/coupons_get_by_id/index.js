const AWS = require('aws-sdk');

// Configure AWS SDK to use LocalStack
AWS.config.update({
  endpoint: 'http://localhost:4566',
  region: 'us-east-1',
  accessKeyId: 'test',
  secretAccessKey: 'test'
});

const dynamoDB = new AWS.DynamoDB.DocumentClient();

exports.handler = async function(event, context) {
  // Extract the coupon id from the path parameters
  const couponId = event.pathParameters.id;

  const params = {
    TableName: 'coupons',
    Key: {
      coupon_id: couponId
    }
  };

  try {
    const result = await dynamoDB.get(params).promise();
    
    if (result.Item) {
      // Format the response according to the sample structure
      const response = {
        coupon_id: result.Item.coupon_id,
        title: result.Item.title,
        description: result.Item.description,
        coupon_code: result.Item.coupon_code,
        campaign_id: result.Item.campaign_id,
        provider_id: result.Item.provider_id,
        provider_name: result.Item.provider_name,
        start_date: result.Item.start_date,
        end_date: result.Item.end_date
      };

      return {
        statusCode: 200,
        body: JSON.stringify(response)
      };
    } else {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: 'Coupon not found' })
      };
    }
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Internal server error' })
    };
  }
};