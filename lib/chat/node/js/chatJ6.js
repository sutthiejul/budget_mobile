const express = require("express");
const fs = require("fs");
const path = require("path");
const cors = require("cors");
const app = express();
const http = require("http").Server(app);

// กำหนด CORS และ Engine Options เพื่อป้องกัน Connection Drop/Loop
const io = require("socket.io")(http, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
    credentials: false
  },
  allowEIO3: true,
  pingInterval: 10000,
  pingTimeout: 5000,
  transports: ["websocket", "polling"]
});

const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  res.write('<h3>Server Ready</h3>');
  res.end();
});

// ที่อยู่จัดเก็บไฟล์ข้อความ
const messageDir = path.join(__dirname, "message");
const messageFile = path.join(messageDir, "messages.json");

if (!fs.existsSync(messageDir)) {
  fs.mkdirSync(messageDir, { recursive: true });
}

let groupMessages = [];
if (fs.existsSync(messageFile)) {
  try {
    const data = fs.readFileSync(messageFile, "utf8");
    groupMessages = JSON.parse(data);
    console.log(`[Storage] โหลดประวัติเดิม ${groupMessages.length} ข้อความ`);
  } catch (err) {
    console.error("[Storage Error] อ่านไฟล์ข้อความล้มเหลว:", err);
    groupMessages = [];
  }
}

function saveMessages(messages) {
  try {
    fs.writeFileSync(messageFile, JSON.stringify(messages, null, 2), "utf8");
  } catch (err) {
    console.error("[Storage Error] บันทึกไฟล์ล้มเหลว:", err);
  }
}

const DEFAULT_ROOM = "กลุ่มเร่งรัดงบประมาณ";
let groupUsers = [];

function getRoomUserCount() {
  const rooms = io.sockets.adapter.rooms;
  if (!rooms) return groupUsers.length;

  if (typeof rooms.get === "function") {
    const room = rooms.get(DEFAULT_ROOM);
    return room ? room.size : 0;
  } else {
    const room = rooms[DEFAULT_ROOM];
    return room ? (room.length || Object.keys(room.sockets || {}).length) : 0;
  }
}

io.on("connection", (socket) => {
  console.log(`[Socket Connected] Socket ID: ${socket.id}`);

  // เมื่อผู้ใช้ Join เข้าห้องกลุ่ม
  socket.on("join_group", (dat) => {
    const userid = (dat && dat.userid) ? dat.userid : "User_" + socket.id.substr(0, 4);
    socket.join(DEFAULT_ROOM);
    socket.room = DEFAULT_ROOM;
    socket.userid = userid;

    if (!groupUsers.includes(userid)) {
      groupUsers.push(userid);
    }

    const currentCount = getRoomUserCount();
    console.log(`[Join Room] ผู้ใช้: ${userid} | ห้อง: ${DEFAULT_ROOM} | สมาชิกปัจจุบัน: ${currentCount} คน`);

    // แจ้งจำนวนคนล่าสุดในกลุ่มให้ทุกคนทราบ
    io.to(DEFAULT_ROOM).emit("group_info", {
      room: DEFAULT_ROOM,
      count: currentCount,
      users: groupUsers
    });

    // ส่งประวัติข้อความเดิมให้
    socket.emit("history", groupMessages);
  });

  // รับ-ส่งข้อความ
  socket.on("msg", (dat) => {
    const username = dat.username || socket.userid || "Unknown";
    const msg = dat.msg || "";
    const timestamp = Date.now();

    console.log(`[New Msg] ${username}: ${msg}`);

    const messageItem = {
      username: username,
      msg: msg,
      timestamp: timestamp
    };

    groupMessages.push(messageItem);

    // ครบ 500 รายการ ให้ล้างและเริ่มเก็บใหม่
    if (groupMessages.length > 500) {
      console.log("[Storage] ครบ 500 บรรทัด ทำการเคลียร์ข้อมูลเดิมและเริ่มบันทึกใหม่");
      groupMessages = [messageItem];
    }

    saveMessages(groupMessages);
    io.to(DEFAULT_ROOM).emit("msg", messageItem);
  });

  socket.on("disconnect", (reason) => {
    console.log(`[Socket Disconnected] ID: ${socket.id} | Reason: ${reason}`);

    if (socket.userid) {
      const idx = groupUsers.indexOf(socket.userid);
      if (idx > -1) {
        groupUsers.splice(idx, 1);
      }
    }

    io.to(DEFAULT_ROOM).emit("group_info", {
      room: DEFAULT_ROOM,
      count: getRoomUserCount(),
      users: groupUsers
    });
  });
});

http.listen(PORT, "0.0.0.0", () => {
  console.log(`=======================================`);
  console.log(` Server is running on port: ${PORT}`);
  console.log(`=======================================`);
});