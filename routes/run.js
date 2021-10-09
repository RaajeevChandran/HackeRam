const express = require("express")
const router = express.Router()
const {RUN} = require("../controllers/run")

router.post("/run",RUN)

module.exports=router