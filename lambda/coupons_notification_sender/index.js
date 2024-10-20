const AWS = require("aws-sdk");
const sns = new AWS.SNS();

exports.handler = async (event) => {
  try {
    // Log the received event
    console.log("Received event:", JSON.stringify(event, null, 2));

    // Prepare the notification message
    const message = `
            Dear customer,

            We are glad to inform you that a new coupon is available in our system:
            Coupon code: ${event.coupon_code}
            Title: ${event.title}
            Description: ${event.description}

            Enjoy,
            Ideal Trip Team
        `;

    const params = {
      Message: message,
      Subject: `New Coupon: ${event.title}`,
      TopicArn: `arn:aws:sns:us-east-1:000000000000:coupons`, // Change the region/account ID as needed
    };

    // Publish to SNS topic
    const result = await sns.publish(params).promise();
    console.log("Successfully published to SNS:", result);

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Successfully sent notification",
        event_id: event.event_id,
      }),
    };
  } catch (error) {
    console.error("Error sending notification:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Failed to send notification",
        error: error.message,
      }),
    };
  }
};
