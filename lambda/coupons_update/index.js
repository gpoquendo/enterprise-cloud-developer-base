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
  
  // Parse the update data from the request body
  const updateData = JSON.parse(event.body);

  // Prepare the update expression and attribute values
  let updateExpression = 'set';
  let expressionAttributeValues = {};
  let expressionAttributeNames = {};

  for (const [key, value] of Object.entries(updateData)) {
    if (key !== 'coupon_id') {  // Skip the primary key
      updateExpression += ` #${key} = :${key},`;
      expressionAttributeValues[`:${key}`] = value;
      expressionAttributeNames[`#${key}`] = key;
    }
  }

  // Remove the trailing comma
  updateExpression = updateExpression.slice(0, -1);

  const params = {
    TableName: 'coupons',
    Key: {
      coupon_id: couponId
    },
    UpdateExpression: updateExpression,
    ExpressionAttributeValues: expressionAttributeValues,
    ExpressionAttributeNames: expressionAttributeNames,
    ReturnValues: 'ALL_NEW'
  };

  try {
    const result = await dynamoDB.update(params).promise();
    
    return {
      statusCode: 200,
      body: JSON.stringify(result.Attributes)
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Internal server error' })
    };
  }
};