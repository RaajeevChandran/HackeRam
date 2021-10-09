const express = require("express")
const router = express.Router()
const {DETECT} = require("../controllers/detect")

router.post("/detect",DETECT)


module.exports=router