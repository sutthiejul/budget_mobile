const express = require("express");
const crypto = require("crypto");
const fs = require("fs");
const app = express();
const http = require("http").Server(app);
const io = require("socket.io")(http);
const PORT = process.env.PORT || 3000;

app.use(require("cors")());
app.use(require("express").json());

app.get("/", (req, res) => {
res.writeHead(200, { "Content-Type": "text/html" });
res.write(
 '<html><body><h3>This URL Using Call API only!!!</h3><p style="font-weight: bold ; color : blue">Test By Sutthie J..</p></body></html>'
   );
   res.end();
 });

const path = require("path");

//app.get("/", (req, res) => {
  //res.sendFile(__dirname + "/chat_node.htm");

  //res.sendFile(__dirname + "../chat_node.htm");
  //res.sendFile('index.html', { root: __dirname });
//});

app.get("/close", (req, res) => {
  
});

//========================Chat Manage=======================
//var client_cnt = 0;
var users = [];

io.on("connection", (socket) => {
  //console.log("a user connected : " + users.length);

  socket.on("setUserName", (usrname) => {
    if (users.indexOf(usrname) > -1) {
      // if have in array
      /*      socket.emit(
        "usrnameExist",
        usrname + " มีผู้ใช้ชื่อนี้แล้ว กรุณาป้อนชื่อใหม่"
      );*/
    } else {
      // no have in array
      users.push(usrname);
      //console.log("set name : " + usrname);
      console.log("a user connected : " + users.length);
      socket.emit("usrnameSet", { usrname: usrname });
      io.sockets.emit("user_online", users);
    }
  });

  io.sockets.emit("broadcast", {
    type: "cnt_online",
    txt: users.length,
  });

  socket.emit("greeting", {
    txt: "Good Day,WelCome !!!",
  });

  // io.sockets.emit("cnt_user_online", {
  //   //txt: "connect number :" + client_cnt,
  //   cnt: users.length,
  // });

  socket.on("clientMsg", function (msg) {
    console.log(msg.txt);
  });

  socket.on("private", (dat) => {
    console.log(dat);

    // console.log(
    //   ("from : " + dat.from + " | to : " + dat.to + " | msg : " + dat.msg) |
    //     (" | date time : " + dat.datetime)
    // );

    io.sockets.emit("private", dat);
  });

  socket.on("inroom", (dat) => {
    console.log(
      "room : " +
        dat.room +
        " | from : " +
        dat.userid +
        " | in room msg : " +
        dat.msg +
        " | date time : " +
        dat.datetime
    );

    io.to(dat.room).emit("inroom", dat);
  });

  socket.on("join", (dat) => {
    socket.join(dat.room);
    //io.to(dat.room).emit("private", "my room : " + dat.room);
    console.log("User Name : " + dat.userid + " | join room : : " + dat.room);
  });

  //listen
  socket.on("msg", (dat) => {
    console.log("ข้อความ : " + dat.msg + " | ชื่อ : " + dat.userid);

    // reply
    //io.sockets.emit("msg", dat.msg + " | " + dat.userid);
    io.sockets.emit("msg", dat);
  });

  socket.on("clear_user", function () {
    //client_cnt = 0;
    users = [];

    //console.log("User Online : " + client_cnt + "\n" + " User : " + users);

    io.sockets.emit("clear_user", "");
  });

  socket.on("get_user_online", function () {
    console.log("\nUser Online : " + users.length + "\n");

    for (var i = 0; i < users.length; i++) {
      console.log(users[i]);
    }

    io.sockets.emit("user_online", users);
  });

  // socket.on("cnt_user_online", function () {
  //   console.log("\nUser Online : " + users.length + "\n");

  //   // for (var i = 0; i < users.length; i++) {
  //   //   console.log(users[i]);
  //   // }

  //   io.sockets.emit("cnt_user_online", users.length);
  // });

  socket.on("kick", (userid) => {
    console.log("userid : " + userid);

    users.splice(users.indexOf(userid), 1);

    io.sockets.emit("kick", userid);
    //socket.emit("kick", { userid: userid });
    //io.sockets.emit("kick", { userid: userid });
  });

  socket.on("logout", (userid) => {
    console.log("a user disConnected : " + userid);

    //remove userid in array
    users.splice(users.indexOf(userid), 1);
    io.sockets.emit("logout", users);

    //socket.close();
    socket.disconnect();
    // client_cnt--;
  });

  socket.on("disconnect", () => {
    console.log("\nUser Current Online : " + users.length);
    io.sockets.emit("broadcast", {
      type: "cnt_online",
      txt: users.length,
    });
    for (var i = 0; i < users.length; i++) {
      console.log(`${i + 1}) ` + users[i]);
    }
  });

  socket.on("error", function (err) {
    console.log("\nOn Error :\n" + err);
  });
});

http.listen(PORT, "0.0.0.0", () => {
  console.log(`App listening http://10.130.228.3:${PORT}`);
});
