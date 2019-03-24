let express = require('express');
let app = express();
let bodyParser = require("body-parser");
let expressWs = require('express-ws')(app);
let cryptoJS = require("crypto-js");



const mariadb = require('mariadb');
const pool = mariadb.createPool({
     host:'feb7.host.cs.st-andrews.ac.uk', 
     user:'feb7', 
     password:'9C44Tx6!sZe9R7',
     connectionLimit: 5,
     compress : true,
     database : 'feb7_cs3101_Practical2_db'
});


app.ws('/database', function(ws, req) {
    ws.on('message', function(msg) {
        handleClientMessage(ws, msg);
    });
});


function handleClientMessage(ws, msg){
    let json = JSON.parse(msg);

    switch (json.type){
            case 'test':
                var msg = {'type' : 'recieved'}
                sendDetails(JSON.stringify(msg),ws,json.type);
                break;
            case 'query1' :
                console.log("query recieved");
                asyncFunction("select * from q1", ws,json.type)
                break;   
            case 'query2' :
                console.log("query recieved");
                asyncFunction("select * from q2", ws,json.type)
                break;
            case 'query3' :
                console.log("query recieved");
                asyncFunction("select * from q3", ws,json.type)
                break;  
            case 'allBooks' :
                console.log("query recieved");
                asyncFunction("select * from audiobook inner join person on audiobook.narrator_id = person.ID order by title asc", ws, json.type)
                break;  
            case 'login':
                checkPassword(JSON.stringify(json.username), JSON.stringify(json.password), ws)
                break; 

            case 'register':
                asyncFunction('insert into login values (' + JSON.stringify(json.username) + ',"' + cryptoJS.SHA1(JSON.stringify(json.password)).toString(cryptoJS.enc.Base64) + '")' ,ws ,json.type);
                break;    

            default:
                var query = 'select * from audiobook,audiobookReview where audiobook.ISBN = audiobookReview.ISBN and audiobook.ISBN = '+ JSON.stringify(json.type)
                asyncFunction(query, ws,'review')
                break;
    }

}

function sendDetails(msg, ws){
    ws.send(msg);
}

async function checkPassword(username, password, ws){
    console.log(username + " " +password);
    var hash = cryptoJS.SHA1(password).toString(cryptoJS.enc.Base64);
    var query = 'select username, password from login where username = ' + username;

    try {
        conn = await pool.getConnection();
        var ret = await conn.query(query, username);
        
        if(ret.length == 0 || ret[0].password != hash){
            var msg = {"type" : "passwordNotVerified"}
        }

        else{
            msg = {"type" : "passwordVerified"}
        }
        
        sendDetails(JSON.stringify(msg), ws);
      } 
      
      catch (err) {
        throw err;
      } 
      
      finally {
        if (conn) return conn.end();
      } 
}

async function asyncFunction(query, ws, queryName) {
    let conn;
    try {
      conn = await pool.getConnection();
      const ret = await conn.query(query);
      var msg = {'type' :  queryName, 'result' : ret};
      sendDetails(JSON.stringify(msg), ws);

    } catch (err) {
      throw err;
    } finally {
      if (conn) return conn.end();
    }
  }

app.use(express.static(__dirname + '/static'));

// Log any server-side errors to the console and send 500 error code.
app.use(function (err, req, res, next) {
    console.error(err.stack);
    res.status(500).send('Something broke!')
});

app.listen(8080);
console.log('Server running, access by going to http://127.0.0.1:8080/cs3101Practical2.html');
