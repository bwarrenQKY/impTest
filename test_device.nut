server.log("Johnny 5 is alive");

ambientLight <- 0;

function sendToAgent()
{
    agent.send("AmbientLightReading", ambientLight);
}

function readLight()
{
    ambientLight = hardware.lightlevel();
    sendToAgent();
    imp.wakeup(11, readLight.bindenv(this));

    server.log("I want to add a way to alert a user of a big change in light");
}

readLight();
