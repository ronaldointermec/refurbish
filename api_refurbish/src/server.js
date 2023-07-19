const express = require("express");
const routes = require("./routes");
const cors = require("cors");
require("./database");

const app = express();

/*
var corsOptions = {
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    preflightContinue: false,
    optionsSuccessStatus: 200
  }

*/

app.use(cors());
app.use(express.json());
app.use("/refurbish", routes);

app.listen(3333, "0.0.0.0");
//app.listen(8096,'0.0.0.0');
