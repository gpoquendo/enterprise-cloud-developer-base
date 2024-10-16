const { handler } = require('../index.js');
const jwt = require('jsonwebtoken');

// Use the same secret key as in the Lambda function
const SECRET_KEY = '0HXc4w5NEzA61HkV';

describe('Coupon get token', () => {

  test('Should return success status', async () => {
    // Generate a valid token
    const validToken = jwt.sign({ userId: '12345' }, SECRET_KEY);

    // Mock the event object with an Authorization header
    const event = {
      headers: {
        Authorization: `Bearer ${validToken}`
      }
    };

    // Call the Lambda handler
    const response = await handler(event, null);
    const responseParsed = JSON.parse(response.body);

    // Expected response
    const expectedResponse = { status: 'success' };

    // Assertions
    expect(response.statusCode).toBe(200);
    expect(responseParsed).toStrictEqual(expectedResponse);
  });

  test('Should return 403 if no token is provided', async () => {
    // Mock the event object without the Authorization header
    const event = {
      headers: {}
    };

    // Call the Lambda handler
    const response = await handler(event, null);
    const responseParsed = JSON.parse(response.body);

    // Expected error response
    const expectedErrorResponse = { error: 'No token provided' };

    // Assertions
    expect(response.statusCode).toBe(403);
    expect(responseParsed).toStrictEqual(expectedErrorResponse);
  });

  test('Should return 403 if the token is invalid', async () => {
    // Mock the event object with an invalid token
    const event = {
      headers: {
        Authorization: 'Bearer invalidtoken'
      }
    };

    // Call the Lambda handler
    const response = await handler(event, null);
    const responseParsed = JSON.parse(response.body);

    // Expected error response
    const expectedErrorResponse = { error: 'Invalid token' };

    // Assertions
    expect(response.statusCode).toBe(403);
    expect(responseParsed).toStrictEqual(expectedErrorResponse);
  });

});
