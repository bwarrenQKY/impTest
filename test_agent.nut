server.log("-------------------------------------------");
server.log("AGENT STARTED");
server.log("-------------------------------------------");

firebaseURL <- "https://ghettospotter.firebaseio.com/getLight.json";
header <- { "Content-Type" : "application/json" };
arraySize <- 1000;

ambientLightArray <- array(arraySize, 0);

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
