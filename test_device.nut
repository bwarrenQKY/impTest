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
    imp.wakeup(10, readLight.bindenv(this));
}

readLight();
