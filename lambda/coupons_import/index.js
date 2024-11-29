const AWS = require("aws-sdk");

// Use the LocalStack hostname environment variable
const localstackHost = process.env.LOCALSTACK_HOSTNAME || "localhost"; // Fallback to localhost if the env var is missing

const s3 = new AWS.S3({
  endpoint: `http://${localstackHost}:4566`, // Use LocalStack hostname
  s3ForcePathStyle: true, // Necessary for LocalStack
});

exports.handler = async (event) => {
  const bucketName = "coupons"; // Name of the S3 bucket

  if (!event.body) {
    return {
      statusCode: 400,
      body: JSON.stringify({ status: "error", message: "Missing event body" }),
    };
  }

  const couponData = JSON.parse(event.body); // Assuming event body contains JSON with coupon info
  const couponId = couponData.coupon_id;

  const fileName = `${couponId}.json`; // Create the filename using the coupon_id
  const fileContent = JSON.stringify(couponData); // Convert the coupon data to JSON

  const params = {
    Bucket: bucketName,
    Key: fileName,
    Body: fileContent,
    ContentType: "application/json",
  };

  try {
    // Upload the coupon file to S3
    await s3.putObject(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify({
        status: "success",
        message: "Coupon uploaded successfully",
      }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ status: "error", message: error.message }),
    };
  }
};
