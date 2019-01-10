import ballerina/io;
import wso2/gmail;
import ballerina/http;
import ballerina/config;
import ballerina/test;
import ballerina/log;
import ballerina/mysql;



public function main() {
   createtable();
    userInput();

}

//getting user input for sending mail or creating draft by separately inputing all parameters
function userInput(){

    int operation = 0;
    while (operation !=3){
        // print options menu to choose from
        io:println("Select operation.");
        io:println("1. Update vacations of employees");
        io:println("2. Get vacation details");
        io:println("3. Send mail to an employee");
        io:println("4. Exit");

        // read user's choice
        string val = io:readln("Enter choice 1 - 4: ");
        var choice = int.convert(val);
        if (choice is int) {
            operation = choice;
        } else  {
            io:println("Invalid choice \n");
            continue;
        }

        if (operation == 4) {
            break;
        } else if (operation < 1 || operation > 4) {
            io:println("Invalid choice \n");
            continue;
        }
        io:println(operation);
        if (operation == 1) {
            io:println(" Updating vacation details... ");
            testListLabels();

        } else if(operation ==2){
            string mail_id= io:readln("Enter receipient's email id: ");
            var res = getvacationDetails("chaminda@wso2.com ");
            io:println(res);

        } else if (operation == 3) {

            string receipient= io:readln("Enter receipient's email id: ");
            string msg = io:readln("Enter the msg: ");
            string sub = io:readln("Enter the subject: ");
            sendMail(receipient,msg, sub);
            io:println("Sending Mail... ");

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
