import ballerina/io;
import ballerina/config;

// Getting access token of gmail api
string access_token = config:getAsString("ACCESS_TOKEN");

// Getting client_id of gmail api
string client_id = config:getAsString("CLIENT_ID");

// Getting client secret of gmail api
string client_secret = config:getAsString("CLIENT_SECRET");

//Getting refresh token of gmail api
string refresh_token = config:getAsString("REFRESH_TOKEN");

// MySQL database host name
string host = config:getAsString("HOST");

// MySQL database port id -default is 3306
int port = config:getAsInt("PORT");

// Name of the MySQL database
string dbname = config:getAsString("DB_NAME");

// User name of MySQL database
string user = config:getAsString("USER_NAME");

// Password of MySQL database
string secretkey = config:getAsString("PASSWORD");
