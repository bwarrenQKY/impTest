server.log("Johnny 5 is alive");

ambientLight <- 0;
morningGreeting <- 0;
eveningGreeting <- 0;

function sendToAgent()
{
    agent.send("AmbientLightReading", ambientLight);
}

function alertUser(message)
{
    agent.send("SMS", message);
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
            alertUser("Good morning, sunshine!");
            morningGreeting = 1;
            eveningGreeting = 0;
        }
    }
    if(!eveningGreeting)
    {
        if(ambientLight < 20000)
        {
            server.log("Good evening!");
            alertUser("Buonasera!!");
            eveningGreeting = 1;
            morningGreeting = 0;
        }
    }
    imp.wakeup(10, readLight.bindenv(this));
}

readLight();
