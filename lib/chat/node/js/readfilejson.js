//token_data.json
const fs = require("fs");

const fileData = fs.readFileSync("./token_data.json", "utf8");
const jsonData = JSON.parse(fileData);
console.log(jsonData["secret_key"]);

// jsonData["secret_key"] = "00007000007"
// fs.writeFile("./serverStatus.json", JSON.stringify(jsonData))
