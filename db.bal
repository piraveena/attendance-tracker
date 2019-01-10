import ballerina/io;
import ballerina/mysql;


mysql:Client DB = new({
        host: "localhost",
        port: 3306,
        name: "users",
        username: "root",
        password: "password",
        poolOptions: { maximumPoolSize: 5 },
        dbOptions: { useSSL: false }
    });

function createtable(){
    var ret = DB->update("CREATE TABLE IF NOT EXISTS vacation(id int AUTO_INCREMENT, email_id varchar(255), leave_date varchar(20), PRIMARY KEY(id))");

}

function dbinsertuser(string name, string email_id){
    io:println("\nThe update operation - Inserting data to a table");
    string querysq= "INSERT INTO users(name, email_id) values";
    string user_name = name;
    string mail = email_id;
    string sqlQuery = querysq + "(" + "'"+ user_name +"'" + "," + "'" +mail+ "'" + ")";
    var ret=DB->update(sqlQuery);
    handleUpdate(ret, "Insert to student table with no parameters");
}

function dbinsertleave(string email, string leave_date){
    io:println("\nThe update operation - Inserting data to a table");
    string querysq= "INSERT INTO vacation(email_id, leave_date) values";

    string sqlQuery = querysq + "(" + "'"+ email +"'" + "," + "'" +leave_date+ "'" + ")";
    var ret=DB->update(sqlQuery);
    handleUpdate(ret, "Insert to vacation table with no parameters");
}

function handleUpdate(int|error returned, string message) {
    if (returned is int) {
        io:println(message + " status: " + returned);
    } else {
        io:println(message + " failed: " + <string>returned.detail().message);
    }
}

function getAllEmailId() returns json{
    var selectRet = DB->select("SELECT email_id FROM users", ());
    if (selectRet is table<record {}>) {
        io:println("\nConvert the table into json");
        var jsonConversionRet = json.convert(selectRet);
        if (jsonConversionRet is json) {
            return jsonConversionRet;
        } else {
            io:println("Error in table to json conversion");
        }
    } else {
        io:println("Select data from student table failed: " + <string>selectRet.detail().message);
    }
}

function sanitizeAndReturnTainted(string input) returns string {
    string regEx = "[^a-zA-Z]";
    return input.replace(regEx, "");
}
