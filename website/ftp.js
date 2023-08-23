var Deploy = require('ftp-deploy');
var ftpDeploy = new Deploy();
 
var config = {
    host : "Your FTp Host",
    user : "FTP Username",
    password : "FTP Password",
    port: 21,//FTP Port
    localRoot: __dirname + '/build',
    remoteRoot: '/',
    include: ['*','.htaccess'],
    deleteRemote: true 
}
ftpDeploy.deploy(config, function(err, res) {
    if (err) console.log(err)
    else console.log('finished:', res);
});
ftpDeploy.on("uploading", function(data) {
    data.totalFilesCount; 
    data.transferredFileCount;
    data.filename; 
});
ftpDeploy.on("uploaded", function(data) {
    console.log(data); 
});
ftpDeploy.on("log", function(data) {
    console.log(data);
});
ftpDeploy.on("upload-error", function(data) {
    console.log(data.err);
});