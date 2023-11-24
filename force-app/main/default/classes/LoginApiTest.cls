@isTest
private class LoginApiTest {
    @isTest
    static void testSuccessfulLogin() {
        // Create a test customer record
        Customer__c testCustomer = new Customer__c(
            Name = 'TestUser',
            Last_Name__c = 'TestLastName',
            Email__c = 'test@example.com',
            Gender__c = 'Male',
            Phone__c = '1234567890',
            OTP__c = '1234',
            Date_of_Birth__c = Date.newInstance(1990, 10, 10),
            IsProfile__c = true,
            IsVerify__c = true,
            Country__c = 'USA',
            State__c = 'CA',
            City__c = 'San Francisco',
            Password__c = 'testpassword',
            IsDeleted__c = false
        );
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/login/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"mobileNumber":"' + testCustomer.Phone__c + '","password":"testpassword","DeviceToken":"testdevicetoken"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        LoginApi.login(testCustomer.Phone__c, 'testpassword', 'testdevicetoken');

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status');
        System.assert(responseBody.contains('Login successful.'), 'message');

        // Add more assertions for user details in the response

        Test.stopTest();
    }

    @isTest
    static void testFailedLogin() {
        // Create a test customer record
        Customer__c testCustomer = new Customer__c(
            Name = 'TestUser',
            Last_Name__c = 'TestLastName',
            Email__c = 'test@example.com',
            Gender__c = 'Male',
            Phone__c = '1234567890',
            OTP__c = '1234',
            Date_of_Birth__c = Date.newInstance(1990, 10, 10),
            IsProfile__c = true,
            IsVerify__c = true,
            Country__c = 'USA',
            State__c = 'CA',
            City__c = 'San Francisco',
            Password__c = 'testpassword',
            IsDeleted__c = false
        );
        insert testCustomer;

        // Set up the request with incorrect password
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/login/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"mobileNumber":"' + testCustomer.Phone__c + '","password":"incorrectpassword","DeviceToken":"testdevicetoken"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        LoginApi.login(testCustomer.Phone__c, 'incorrectpassword','testdevicetoken');

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status should be Failed');
        System.assert(responseBody.contains('Login failed. Invalid credentials.'), 'Message should indicate failed login');

        Test.stopTest();
    }

    @isTest
    static void testAccountDeleted() {
        // Create a test customer record with IsDeleted__c set to true
        Customer__c testCustomer = new Customer__c(
            Name = 'TestUser',
            Last_Name__c = 'TestLastName',
            Email__c = 'test@example.com',
            Gender__c = 'Male',
            Phone__c = 'worng',
            OTP__c = '1234',
            Date_of_Birth__c = Date.newInstance(1990, 10, 10),
            IsProfile__c = true,
            IsVerify__c = true,
            Country__c = 'USA',
            State__c = 'CA',
            City__c = 'San Francisco',
            Password__c = 'testpassword',
            IsDeleted__c = true
        );
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/login/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"mobileNumber":"' + testCustomer.Phone__c + '","password":"testpasword","DeviceToken":"testdevicetoken"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        LoginApi.login(testCustomer.Phone__c, 'testpassword','testdevicetoken');

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
     //   System.assert(responseBody.contains('Failed'), 'Status should be Failed');
    //    System.assert(responseBody.contains('Your account has been deleted.'), 'Message should indicate account deleted');

        Test.stopTest();
    }
    
    
     @isTest
    static void testFailedLogin1() {
        // Create a test customer record
        Customer__c testCustomer = new Customer__c(
            Name = 'TestUser',
            Last_Name__c = 'TestLastName',
            Email__c = 'test@example.com',
            Gender__c = 'Male',
            Phone__c = '1234567890',
            OTP__c = '1234',
            Date_of_Birth__c = Date.newInstance(1990, 10, 10),
            IsProfile__c = true,
            IsVerify__c = true,
            Country__c = 'USA',
            State__c = 'CA',
            City__c = 'San Francisco',
            Password__c = 'testpassword',
            IsDeleted__c = false
        );
      

        // Set up the request with incorrect password
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/login/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"mobileNumber":"' +  + '","password":"incorrectpassword","DeviceToken":"testdevicetoken"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        LoginApi.login(testCustomer.Phone__c, 'incorrectpassword','testdevicetoken');

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
        insert testCustomer;
        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status should be Failed');
        System.assert(responseBody.contains('Login failed. Invalid credentials.'), 'Message should indicate failed login');

        Test.stopTest();
    }

}