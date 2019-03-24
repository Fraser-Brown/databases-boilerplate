var ws;

var Client = (function(){

    function init() {
        ws = new WebSocket('ws://localhost:8080/database');
        ws.onmessage = recieveFromServer;
    }

    return {
        init: init
    }

})();

function recieveFromServer(msg){
    let json = JSON.parse(msg.data);
    $('#queryResult').empty();
    switch (json.type){
        case 'recieved':
        alert("message was recieved");
        break;

        case 'passwordVerified':{
            $('#allInputs').empty();
            $("#allInputs").append(
            '<button id="testButton" onclick="sendTest()">Test</button>'+
            '</br>'+
            '<button id="query1Button" onclick="sendQuery(' + "'query1'"+')">Query 1</button>'+
            '</br>'+
            '<button id="query2Button" onclick="sendQuery(' + "'query2'"+ ')">Query 2</button>'+
            '</br>'+
            '<button id="query3Button" onclick="sendQuery(' + "'query3'"+')">Query 3</button>'+
            '</br>'+
            '<button id="queryAllBooksButton" onclick="sendQuery(' + "'allBooks'" +')">Return all audiobooks</button>'+
            '<div id = "queryResult"><h1>Query Results</h1></div>')
            break;
        }
        case 'passwordNotVerified':{
            alert("Username or Password incorrect")
            break;
        }

        case 'register':{
            alert("Username and password added");
            break;
        }
        
        case 'allBooks':
            var r = json.result
            for (var x in r){
                $('#queryResult').append('<p>');
                $('#queryResult').append('ISBN : ' + r[x].ISBN + '</br>');
                $('#queryResult').append('Title : ' + r[x].title + '</br>');
                $('#queryResult').append('Running time : ' + r[x].running_time+ '</br>');
                $('#queryResult').append('Narrator : ' + r[x].forename + " " + r[x].surname+ '</br>');
                $('#queryResult').append("<button onclick = 'sendQuery("+ JSON.stringify(r[x].ISBN) +")'> Reviews </br>");
                $('#queryResult').append('</p></br>');

            }
            
        break;

        case 'review':
            var r = json.result;
            $('#queryResult').append('Title : ' + r[0].title + '</br>');
            for(var x in r){
                $('#queryResult').append('<p>');
                $('#queryResult').append('Rating : ' + r[x].rating + '</br>');
                $('#queryResult').append('Comment : ' + r[x].comment + '</br>');

                $('#queryResult').append('</p></br>');
            }
        break;

        default:
            $('#queryResult').append('<p>' + JSON.stringify(json.result)+'</p></br>');
            break;
    }
}

function sendQuery(query){
    let msg = {'type' : query};
    ws.send(JSON.stringify(msg));
}

function sendTest(){
    let msg = {'type' : 'test'};
    ws.send(JSON.stringify(msg));
}

function sendLogin(){
   var password = document.getElementById("pass").value;
   var username = document.getElementById("username").value;

   document.getElementById("username").value = "";
   document.getElementById("pass").value = ""; 


   let msg = {'type' : 'login', 'username' : username, 'password' : password};
   
   ws.send(JSON.stringify(msg));
}

function register(){
    var password = document.getElementById("pass").value;
    var username = document.getElementById("username").value;
 
    document.getElementById("username").value = "";
    document.getElementById("pass").value = ""; 
 
 
    let msg = {'type' : 'register', 'username' : username, 'password' : password};
    
    ws.send(JSON.stringify(msg));
}