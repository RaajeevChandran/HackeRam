require('dotenv').config();
const express = require("express");
const app = express();
const cors = require("cors")
const bodyParser = require("body-parser");
const decodeRoute = require("./routes/ocr")
const runCodeRoute = require("./routes/run")
const detectRoute = require("./routes/detect")
app.use(cors())
app.use(bodyParser.json());


app.use("/api",decodeRoute);
app.use("/api",runCodeRoute);
app.use("/api",detectRoute);

const port = process.env.PORT || 4000;

//Starting a server
app.listen(port, () => {
  console.log(`app is running at ${port}`);
});
