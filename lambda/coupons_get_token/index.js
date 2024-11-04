const jwt = require('jsonwebtoken');

// Secret key for signing the JWT
const SECRET_KEY = '0HXc4w5NEzA61HkV';

// Hardcoded valid credentials (for simplicity)
const VALID_USERNAME = 'tester1';
const VALID_PASSWORD = 'Pc4RM0AMKy5aSGfD';

exports.handler = async function(event, context) {
  console.log('Received event:', JSON.stringify(event));

  const { username, password } = event;

  // Check if the username and password are provided
  if (!username || !password) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: 'Username and password are required' })
    };
  }

  // Verify the credentials
  if (username !== VALID_USERNAME || password !== VALID_PASSWORD) {
    return {
      statusCode: 403,
      body: JSON.stringify({ error: 'Invalid credentials' })
    };
  }

  // If credentials are valid, generate a JWT
  const token = jwt.sign({ username }, SECRET_KEY, { expiresIn: '1h' }); // Expires in 1 hour
  const expiresIn = 3600; // 1 hour in seconds

  // Return the token and expiration time
  return {
    statusCode: 200,
    body: JSON.stringify({
      token: token,
      expiresIn: expiresIn
    })
  };
};
