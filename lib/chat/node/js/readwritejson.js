//token_data.json
const fs = require("fs");
const fileName = "./node/token_data2.json";
const fileData = fs.readFileSync(fileName, "utf8");
const jsonData = JSON.parse(fileData);

console.log(jsonData["secret_key"]);

// update

jsonData["secret_key"] = "00007000008";
fs.writeFile(fileName, JSON.stringify(jsonData), function (err) {
  if (err) {
    return console.error(err);
  }

  console.log("updated : " + fileName);

  //===========Get Value Lastest Update===================================================
  const fileData = fs.readFileSync(fileName, "utf8");
  const jsonData = JSON.parse(fileData);
  var datUpdate = jsonData["secret_key"];
  console.log("data : " + datUpdate);
});
