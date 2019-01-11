import ballerina/io;
import wso2/gmail;
import ballerina/http;
import ballerina/test;
import ballerina/log;
import ballerina/mysql;

gmail:GmailConfiguration gmailConfig = {
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            accessToken: access_token,
            clientId: client_id,
            clientSecret: client_secret,
            refreshToken: refresh_token
        }
    }
};

string userId = "me";
string sentTextMessageThreadId = "";
string createdDraftId = "";
gmail:Client gmailClient = new(gmailConfig);

function createDraft (string receipient, string msg) {
    log:printInfo("Create Draft");
    gmail:MessageRequest messageRequest = {};
    messageRequest.recipient = receipient;
    messageRequest.sender = "piraveena@wso2.com";
    //messageRequest.cc = testCc;
    messageRequest.messageBody = msg;
    messageRequest.contentType = "text/plain";
    var draftResponse = gmailClient->createDraft(userId, messageRequest, threadId = sentTextMessageThreadId);
    if (draftResponse is string) {
        test:assertTrue(draftResponse != "null", msg = "Create Draft failed");
        createdDraftId = untaint draftResponse;
    } else {
        test:assertFail(msg = <string>draftResponse.detail().message);
    }
}


function sendMail(string receipient, string msg, string subject) {
    io:println(receipient);
    gmail:MessageRequest messageRequest = {};
    messageRequest.recipient = receipient;
    messageRequest.sender = "piraveena@wso2.com";
    //messageRequest.cc = testCc;
    messageRequest.subject = subject;
    //---Set Text Body---
    messageRequest.messageBody = msg;
    messageRequest.contentType = "text/plain";
    //---Set Attachments---
    gmail:AttachmentPath[] attachments = [{ attachmentPath: "/Users/piraveena/Downloads/WSO2_Software_Logo.png", mimeType: "png" }];
    messageRequest.attachmentPaths = attachments;
    log:printInfo("testSendTextMessage");
    //----Send the mail----
    var sendMessageResponse = gmailClient->sendMessage(userId, messageRequest);
    string messageId = "";
    string threadId = "";
    string sentTextMessageId="";
    if (sendMessageResponse is (string, string)) {
        (messageId, threadId) = sendMessageResponse;
        sentTextMessageId = untaint messageId;
        sentTextMessageThreadId = untaint threadId;
        test:assertTrue(messageId != "null" && threadId != "null", msg = "Send Text Message Failed");
    } else {
        test:assertFail(msg = <string>sendMessageResponse.detail().message);
    }
}

//list all labels
function testListLabels() {
    //log:printInfo("ListLabels");
    var listLabelResponse = gmailClient->listLabels(userId);
    //io:println(listLabelResponse[0]);
    if (listLabelResponse is error) {
        test:assertFail(msg = <string>listLabelResponse.detail().message);
    }else {
        foreach int i in 0... 20{
            boolean isEqual = listLabelResponse[i].name.equalsIgnoreCase("vacation");
            if(isEqual==true) {
                testListMessages(listLabelResponse[i].id);
                break;
            }
        }
    }
}

//List All Messages with Label vacation without including Spam and Trash
function testListMessages(string labelid) {
    //get the label id
    log:printInfo("testListAllMessages");
    gmail:MsgSearchFilter searchFilter = { includeSpamTrash: false, labelIds: [labelid] };
    var msgList = gmailClient->listMessages(userId, filter = searchFilter);
    //io:println(msgList);
    if msgList is error{
        test:assertFail(msg = <string>msgList.detail().message);
    }
    var email_list = json.convert(msgList);
    if (email_list is json){
        var mail_list = email_list.messages;
        //io:println(mail_list[0]);
        int x = mail_list.length() -1;
        //io:println(x);
        foreach int i in 0...x{
            //io:println(mail_list[i].messageId is string);
            //io:println(i);
            var msgid = string.convert(mail_list[i].messageId);
            if (msgid is string){
                testReadTextMessage(sanitizeAndReturnUntaintedString(msgid));
            }else {
                io:println("message id is not a string");
            }
            //testReadTextMessage(string.convert(mail_list[i].messageId));
        }
    }else {
        io:println ("error in getting mails");
    }
}

//Reading all the mails to vacation group
function testReadTextMessage(string messageid) {
    //Read mail with message id which was sent in testSendSimpleMessage
    //log:printInfo("testReadTextMessage");
    var response = gmailClient->readMessage(userId, messageid);
    //io:println(response.headerFrom);
    if (response is gmail:Message) {
        var subject = response.headerSubject;

        string subjectLower = subject.toLower();
        if (subjectLower.hasPrefix("leave")){
            var mail_id = response.headerFrom;


            addLeave(sanitizeAndReturnUntaintedString(mail_id), sanitizeAndReturnUntaintedString(subject));
        }

        test:assertEquals(response.id, messageid, msg = "Read text mail failed");
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
}

//"Leave 09-01-2018" subject should be in this format
function addLeave(string mail_id, string sub_data){
    var aar = sub_data.split(" ");
    io:println(aar);
    string id=mail_id.replace(">"," ").split("<")[1];
    io:println(id);
    io:println(sub_data);
    io:println(id.replace(" ",""));
    if(isDate(aar[1])==true){
        dbinsertleave(id, aar[1]);
    } else {
        io:println("Error in date format");
    }



}
//([0-9]{2}\-){2}[0-9]{4}

function isDate(string input) returns boolean {
    string regEx = "([0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9])";
    //string regEx1 = "[0-9][0-9]|[0-9][0-9]|[0-9][0-9][0-9][0-9])";
    boolean|error isInt = input.matches(regEx);
    //boolean |error isInt1 = input.matches(regEx1)
    if (isInt is error) {
        panic isInt;
    } else {
        return isInt;
    }
}

function sanitizeAndReturnUntaintedString(string input) returns @untainted string {
    return input;
}

