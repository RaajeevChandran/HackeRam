require("dotenv").config()
const qs = require("querystring");
const axios = require("axios");


exports.RUN = async (req,res)=>{
    const stringifiedData = qs.stringify({
        client_secret: process.env.HACKEREARTH_API_KEY,
        source: req.body.code,
        lang: req.body.language
      });
      // try getting result of code
      try {
        const { data } = await axios.post("https://api.hackerearth.com/v3/code/run/", stringifiedData);
        const result = { message: data.message, errors: data.errors };
        console.log(data);
        if (data.run_status != null) {
          const { run_status } = data;
          result.output = run_status.output;
          if (run_status.status != "AC") {
            const { status, status_detail, stderr } = run_status;
            if (result.errors == null) result.errors = {};
            result.errors[`${status}: ${status_detail}`] = stderr;
          }
        }
        return res.json(result);
      } catch (error) {
        // something oofed
        console.log("Error:", error.message);
        if (error.response) return res.json("error in resp "+error.response.data);
        return res.json("error is "+error);
      }
}