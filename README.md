# vacation_counter

The application can read the mails to vacation group and count the number of leaves taken by employees of wso2. The leave data will be stored in mysql database. When the HR person need details about the leaves taken by an employee, he can input the email_id and get the details about the employee’s leaves. 

If there is any inquiries or further details the HR person needs, then he can send mail to the employee and can notify the employee via sms.

## Functionalities
1. Adding vacations taken by employees using vacation mailing thread for wso2 employees to MySQL database
2. Retrieving the details of vacation taken by the employees
3. Sending mails to employees in case any need about the vacation taken and notifying through sms.


## Compatibility

| Ballerina Language Version  |
|:---------------------------:|
| 0.990.2                     |

##### Prerequisites
Download the ballerina [distribution](https://ballerinalang.org/downloads/).

## Getting started

1.  * Clone the repository by running the following command

         
   ```shell
     	https://github.com/piraveena/vacation_counter.git
   ```
   
   * Initialize the ballerina project.
    
  ```shell
         	ballerina init
  ```


2. Create a ballerina.conf file and add the following inputs.

3.  To use gmail endpoint, you need to provide the collowing in the config file:
    - CLIENT_ID
    - CLIENT_SECRET
    - ACCESS TOKEN
    - REFRESH_TOKEN

4.  To use Twilio endpoint, you need to provide the following in the config file:

       - TWILLO_USERNAME
       - WILLO_PASSWORD
       
5.  To use MySQL database, you need to provide the following in the config file:

       - DB_HOST
       - PORT
       - DB_NAME
       - USER_NAME
       - PASSWORD



7. Run the module as follows:

	```ballerina
	ballerina run vacation_counter/
	```
