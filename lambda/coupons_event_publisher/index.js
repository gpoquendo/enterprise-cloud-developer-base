const AWS = require("aws-sdk");
const kinesis = new AWS.Kinesis({
  endpoint: "http://host.docker.internal:4566",
  region: "us-east-1",
  accessKeyId: "test",
  secretAccessKey: "test",
});

exports.handler = async (event) => {
  try {
    // Log the received event
    console.log("Received event:", JSON.stringify(event, null, 2));

    // Prepare the data to publish to the Kinesis stream
    const data = JSON.stringify({
      event_id: event.event_id,
      event_type: event.event_type,
      coupon_id: event.coupon_id,
      title: event.title,
      description: event.description,
      coupon_code: event.coupon_code,
      start_date: event.start_date,
      end_date: event.end_date,
    });

    const params = {
      Data: data,
      PartitionKey: event.provider_id || "default", // Ensure a partition key
      StreamName: "coupons", // The Kinesis stream name
    };

    // Publish to Kinesis stream
    const result = await kinesis.putRecord(params).promise();
    console.log("Successfully published to Kinesis:", result);

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Successfully published to Kinesis",
        event_id: event.event_id,
      }),
    };
  } catch (error) {
    console.error("Error publishing to Kinesis:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Failed to publish to Kinesis",
        error: error.message,
      }),
    };
  }
};
