const formidable = require("formidable")
const {Storage, File} = require('@google-cloud/storage');
const vision = require('@google-cloud/vision');


const client = new vision.ImageAnnotatorClient();

exports.OCR = (req,res) =>{
    let form = new formidable.IncomingForm()
    form.keepExtensions = true
    form.parse(req,(err,fields,files)=>{
        if (err) {
            console.log('some error', err)
          } else if (!files.file) {
            console.log('no file received')
          } else {
        const gcs = new Storage({
            projectId: 'superb-celerity-310510',
            keyFilename: './superb-celerity-310510-b1af358fa64d.json'
        });
        const bucket = gcs.bucket('testingbuck');
        console.log(`path is ${files.file.path} and name is ${files.file.name}`);
        bucket.upload(files.file.path, function(err, file) {
            if (err) res.send(`error in upload - ${err}`);
            else{
                console.log("uploaded and file name is"+file.name)

        client
        .textDetection(`https://storage.googleapis.com/testingbuck/${file.name}`)
        .then(results => {
        const result = results[0].textAnnotations[0]["description"];
        console.log(result)
        res.send(`${result}`)
        })
        .catch(err => {
            console.error('ERROR:', err);
            res.send(`${err}`)
        }); 
            }
        });
    }})
}