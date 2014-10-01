server.log("-------------------------------------------");
server.log("AGENT STARTED");
server.log("-------------------------------------------");

firebaseURL <- "https://ghettospotter.firebaseio.com/getLight.json";
header <- { "Content-Type" : "application/json" };
arraySize <- 1000;

twilioURL <- "https://AC8e205884fb42550456cfff34546b06e2:c61c522555f96608acd1b6015b9ee823@api.twilio.com/2010-04-01/Accounts/AC8e205884fb42550456cfff34546b06e2/Messages.json";
twilioHeader <- { "Content-Type" : "application/x-www-form-urlencoded" };
numberTo <- "+12485066095";
numberFrom <- "+13139243504";

ambientLightArray <- array(arraySize, 0);

function sendSMS(bodyMessage)
{
    server.log("Sending out an S M S...");

    local body = format("To=%s&From=%s&Body=%s", numberTo, numberFrom, bodyMessage);
    local request = http.post(twilioURL, twilioHeader, body);
    local response = request.sendasync(function(done) {});
}

function postToFirebase(ambientLightReading)
{
    ambientLightArray.remove(0);    
    ambientLightArray.push(ambientLightReading);
    //server.log("Array size is " + ambientLightArray.len());
    
    local dataTable = {};
    dataTable["Ambient Light"] <- ambientLightArray;
    
    server.log("Posting to Firebase");
    server.log("Ambient Light = " + ambientLightReading);

    local preparedPost;
    preparedPost = http.put(firebaseURL, header, http.jsonencode(dataTable));
    preparedPost.sendsync();
}

device.on("AmbientLightReading", postToFirebase);
device.on("SMS", sendSMS);

