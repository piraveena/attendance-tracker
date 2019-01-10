import ballerina/io;
import wso2/gmail;
import ballerina/http;
import ballerina/config;
import ballerina/test;
import ballerina/log;
import ballerina/mysql;



public function main() {

    //userInput();
    //dbinsert();
    //insertIntodb();
    //createDraft();
    //sendingsms("testx","94776099594");
    //testListMessages() ;
    //createtable();
    //sendMail();
    testListLabels();

    //insert();
}

//getting user input for sending mail or creating draft by separately inputing all parameters
function userInput(){

    int operation = 0;
    while (operation !=3){
        // print options menu to choose from
        io:println("Select operation.");
        io:println("1. Create Draft");
        io:println("2. Send Mail");
        io:println("3. Exit");

        // read user's choice
        string val = io:readln("Enter choice 1 - 3: ");
        var choice = int.convert(val);
        if (choice is int) {
            operation = choice;
        } else  {
            io:println("Invalid choice \n");
            continue;
        }

        if (operation == 3) {
            break;
        } else if (operation < 1 || operation > 5) {
            io:println("Invalid choice \n");
            continue;
        }
        io:println(operation);
        if (operation == 1) {
            io:println(" Creating Draft... ");
            string receipient= io:readln("Enter receipient's email id: ");
            string msg = io:readln("Enter the msg: ");
            createDraft(receipient,msg);


        } else if (operation == 2) {
            io:println("Sending Mail... ");
            string receipient= io:readln("Enter receipient's email id: ");
            string msg = io:readln("Enter the msg: ");
            string sub = io:readln("Enter the subject: ");
            sendMail(receipient,msg, sub);

        } else {
            io:println("Invalid choice");
        }
    }
}

//creating a new user
function insertIntodb(){
    io:println(" Inserting new user.. ");
    string name = io:readln("Enter the user's name: ");
    string email_id= io:readln("Enter user's email id: ");

    dbinsertuser(name, email_id);
}

//sending mail to all users
function sendMailToAll(){
    json allemail= getAllEmailId();
    int x = allemail.length() -1;
    json untained_mail= sanitizeAndReturnUntainted(allemail);
    foreach int i in 0... x{
        var mail_id= string.convert(untained_mail[i].email_id);
        if (mail_id is string){
            io:println((mail_id));
            sendMail(mail_id, "hi woowww", "hi");
        }
        else {
            io:println("Error");
        }

    }
}


//Making the input as untained
function sanitizeAndReturnUntainted(json input) returns @untainted json {

    return input;
}

