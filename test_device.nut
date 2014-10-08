server.log("Johnny 5 is alive");

ambientLight <- 0;
morningGreeting <- 0;
eveningGreeting <- 0;
pingStart <- 0;
pingStop <- 0;
pingTime <- 0;

function sendToAgent()
{
    agent.send("AmbientLightReading", ambientLight);
}

function alertUser(message)
{
    agent.send("SMS", message);
}

function ping()
{
    pingStart = hardware.millis();    
    agent.send("Ping", pingTime);
}

function getPingTime(errorCode)
{
    pingStop = hardware.millis();
    pingTime = pingStop - pingStart;

    imp.wakeup(30, main.bindenv(this));
}

function readLight()
{
    ambientLight = hardware.lightlevel();
    sendToAgent();

    if(!morningGreeting)
    {
        if(ambientLight > 40000)
        {        
            server.log("Good morning!");
            //alertUser("Good morning, sunshine!");
            morningGreeting = 1;
            eveningGreeting = 0;
        }
    }
    if(!eveningGreeting)
    {
        if(ambientLight < 20000)
        {
            server.log("Good evening!");
            //alertUser("Buonasera!!");
            eveningGreeting = 1;
            morningGreeting = 0;
        }
    }
}

function main()
{
    readLight();
    ping();    

    //imp.wakeup(30, main.bindenv(this));
}

main();

agent.on("Pong", getPingTime);
