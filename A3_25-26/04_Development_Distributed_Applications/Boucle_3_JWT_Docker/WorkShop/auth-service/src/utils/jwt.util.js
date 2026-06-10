const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.JWT_SECRET || "defaultSecret";
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || "1h";

function generateToken(payload) {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
}

function verifyToken(token) {
  try {
    return jwt.verify(token, JWT_SECRET);
  } catch (error) {
    return null; // token invalide ou expiré
  }
}

function decodeToken(token) {
  return jwt.decode(token);
}

module.exports = {
  generateToken,
  verifyToken,
  decodeToken
};
