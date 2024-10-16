// Import necessary modules
const jwt = require('jsonwebtoken');

const secret = '0HXc4w5NEzA61HkV';

// Helper function to generate a JWT
const generateToken = (username) => {
    const token = jwt.sign({ username }, secret, { expiresIn: '1h' }); // You can set the expiration time as needed
    return token;
};

exports.handler = async (event) => {
    const token = event.headers?.Authorization;

    console.log('Received token:', token);

    if (!token) {
        return {
            statusCode: 403,
            body: JSON.stringify({ message: 'Token not provided' }),
        };
    }

    try {
        // Validate token
        const decoded = jwt.verify(token.split(' ')[1], secret);
        // Add further logic for what should happen if the token is valid
        return {
            statusCode: 200,
            body: JSON.stringify({ message: 'Token is valid', user: decoded }),
        };
    } catch (error) {
        console.error(error);
        return {
            statusCode: 403,
            body: JSON.stringify({ message: 'Token validation failed' }),
        };
    }
};

// Example of generating a token (You can run this separately to generate a valid token)
const validToken = generateToken('tester1');
console.log('Generated Token:', validToken);
