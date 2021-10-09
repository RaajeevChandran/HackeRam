const formidable = require("formidable")
const Algorithmia = require("algorithmia");


exports.DETECT = (req,res)=>{
    var input = req.body.code;
    Algorithmia.client("simzCWqQM0NuerTBZVBltjeTvJX1")
    .algo("PetiteProgrammer/ProgrammingLanguageIdentification/0.1.3?timeout=300") // timeout is optional
    .pipe(input)
    .then(function(response) {
    console.log(response.get());
    return res.json(response.get()[0][0]);
  });
}