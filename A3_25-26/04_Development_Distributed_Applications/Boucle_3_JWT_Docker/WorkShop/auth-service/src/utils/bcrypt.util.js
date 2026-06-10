const bcrypt = require("bcrypt");

const SALT_ROUNDS = parseInt(process.env.SALT_ROUNDS, 10) || 10;

async function hashPassword(password) {
  return await bcrypt.hash(password, SALT_ROUNDS);
}

async function comparePassword(password, hash) {
  return await bcrypt.compare(password, hash);
}

module.exports = {
  hashPassword,
  comparePassword
};
