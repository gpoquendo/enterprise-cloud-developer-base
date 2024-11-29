const AWS = require("aws-sdk");
const s3 = new AWS.S3();

exports.handler = async (event) => {
  const bucketName = "coupons"; // Name of the S3 bucket
  const fileName = event.filename; // Get the filename from the event

  const params = {
    Bucket: bucketName,
    Key: fileName,
    Expires: 60, // URL expiration time in seconds
    ContentType: "application/json",
  };

  try {
    // Generate the pre-signed URL
    const url = s3.getSignedUrl("putObject", params);
    return {
      statusCode: 200,
      body: JSON.stringify({
        status: "success",
        presigned_url: url,
      }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        status: "error",
        message: error.message,
      }),
    };
  }
};
