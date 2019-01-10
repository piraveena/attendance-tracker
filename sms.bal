import ballerina/io;
import ballerina/http;

http:Client clientEndpoint = new("https://api.twilio.com", config = {
        auth: {
            scheme: http:BASIC_AUTH,
            username: "AC12d2895c9b5b77db5d52caafff59f0f9",
            password: "4fbac3ab552a78a3ad82e2ba45d94db4"
        }
    });

//sending sms
function sendingsms(string sms, string user_number){
    http:Request req = new;
    string smsmsg = sms;
    req.setTextPayload("From=%2B18647322003&To=%2B"+user_number+"&Body="+smsmsg);
    req.setHeader("Content-Type", "application/x-www-form-urlencoded");

    io:println(req.getPayloadAsString());

    var response = clientEndpoint->post("/2010-04-01/Accounts/AC12d2895c9b5b77db5d52caafff59f0f9/Messages.json", req);
    if (response is http:Response) {
        var msg = response.getJsonPayload();
        if (msg is json) {
            io:println(msg.toString());
        } else {
            log:printError("Response is not json", err = msg);
        }
    } else {
        log:printError("Invalid response", err = response);
    }
}

