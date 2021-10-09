const express = require("express")
const router = express.Router()
const {OCR} = require("../controllers/ocr")

router.post("/ocr",OCR)


module.exports=router