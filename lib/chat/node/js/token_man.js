const jwt = require("jsonwebtoken");
const fs = require("fs");
const tokenData = require("./token_data.json");
const crypto = require("crypto");

class TokenManager {
  static getGenAccessToken(payload) {
    setTimeout(function () {
      console.log("\n App Times out 1 minute(300s) !!!");
    }, 300000);
    console.clear();
    console.log("\n App Begin Time !!!");
    return jwt.sign(payload, tokenData["secret_key"], { expiresIn: "300s" });
    // let crypto_random = require("crypto").randomBytes(64).toString("hex");
    // return jwt.sign(payload, crypto_random, { expiresIn: "20s" });
  }

  static checkAuthen(request) {
    try {
      let accessToken = request.headers.authorization.split(" ")[1];
      let jwtResponse = jwt.verify(
        String(accessToken),
        tokenData["secret_key"] // get from token_data.json
      );

      return jwtResponse;
    } catch (err) {
      return false;
    }
  }

  static checkAuthenToken(token) {
    try {
      let accessToken = token;
      let jwtResponse = jwt.verify(
        String(accessToken),
        tokenData["secret_key"]
      );

      return jwtResponse;
    } catch (err) {
      return "";
    }
  }

  static generateAccessToken(dat) {
    let crypto_random = require("crypto").randomBytes(64).toString("hex");
    console.log(
      "UserName : " +
        dat["username"] +
        " | Crypto Random 64 bit : " +
        crypto_random
    );
    return jwt.sign(dat, crypto_random, { expiresIn: "20s" });
  }

  static getSecretKey() {
    return require("crypto").randomBytes(64).toString("hex");
  }
}

//console.log("SecretKey : " + TokenManager.getSecretKey());

module.exports = TokenManager;
