@isTest
private class Complete_Profile_ApiTest {

    @isTest
    static void testCompleteProfile_Success() {
        // Create test data
        Customer__c testCustomer = new Customer__c(
            Name = 'TestUser',
            Email__c = 'test@example.com',
            Password__c = 'password',
            IsProfile__c = false,
            IsVerify__c = false
        );
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/completeProfile/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '","password":"newpassword","confirmPassword":"newpassword"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Complete_Profile_Api.completeProfile(testCustomer.Id, 'newpassword', 'newpassword');

        // Perform assertions
    //    System.assertEquals(200, res.statusCode, 'Expected HTTP 200 status code');
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status');
        System.assert(responseBody.contains('Your Profile is Successfully Completed.'), 'message');

        // Query the database to ensure that the record was updated
        Customer__c updatedCustomer = [SELECT Id, IsProfile__c, IsVerify__c, Password__c FROM Customer__c WHERE Id = :testCustomer.Id];
        System.assertEquals(true, updatedCustomer.IsProfile__c, 'IsProfile should be true');
        System.assertEquals(true, updatedCustomer.IsVerify__c, 'IsVerify should be true');
        System.assertEquals('newpassword', updatedCustomer.Password__c, 'Password should be updated');

        // Query the User_Notification__c object to ensure a notification is created
        User_Notification__c userNotification = [SELECT Id, Customer__c, Name, Message__c FROM User_Notification__c WHERE Customer__c = :testCustomer.Id];
        System.assertNotEquals(null, userNotification, 'User Notification should be created');
        System.assertEquals('Congratulations!TestUser', userNotification.Name, 'Notification Name');
        System.assertEquals('Dear TestUser ! You have completed your profile. Thanks for providing your information. Your profile is now fully set up.', userNotification.Message__c, 'Notification Message');

        // End the test
        Test.stopTest();
    }

   

@isTest
    static void testCompleteProfile_PasswordMismatch() {
        // Create test data
        Customer__c testCustomer = new Customer__c(
            Name = 'TestUser',
            Email__c = 'test@example.com',
            Password__c = 'password',
            IsProfile__c = false,
            IsVerify__c = false
        );
        insert testCustomer;

        // Set up the request with mismatched passwords
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/completeProfile/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '","password":"newpassword","confirmPassword":"mismatchedpassword"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Complete_Profile_Api.completeProfile(testCustomer.Id, 'newpassword', 'mismatchedpassword');

        // Perform assertions
     //   System.assertEquals(200, res.statusCode, 'Expected HTTP 200 status code');
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status');
        System.assert(responseBody.contains('Password and Confirm Password do not match.'), 'message');

        // Query the database to ensure that the record was not updated
        Customer__c updatedCustomer = [SELECT Id, IsProfile__c, IsVerify__c, Password__c FROM Customer__c WHERE Id = :testCustomer.Id];
        System.assertEquals(false, updatedCustomer.IsProfile__c, 'IsProfile should remain false');
        System.assertEquals(false, updatedCustomer.IsVerify__c, 'IsVerify should remain false');
        System.assertEquals('password', updatedCustomer.Password__c, 'Password should not be updated');

        // Query the User_Notification__c object to ensure no notification is created
        List<User_Notification__c> userNotifications = [SELECT Id FROM User_Notification__c WHERE Customer__c = :testCustomer.Id];
        System.assertEquals(0, userNotifications.size(), 'No User Notification should be created');

        // End the test
        Test.stopTest();
    }
    
    
    
      @isTest
    static void testCompleteProfile_CatchBlocks() {
        // Create test data
        Customer__c testCustomer = new Customer__c(
            Name = 'TestUser',
            Email__c = 'test@example.com',
            Password__c = 'password',
            IsProfile__c = false,
            IsVerify__c = false
        );
       

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/completeProfile/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '","password":"newpassword","confirmPassword":"newpassword"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Complete_Profile_Api.completeProfile(testCustomer.Id, 'newpassword', 'newpassword');

        // Perform assertions
    //    System.assertEquals(200, res.statusCode, 'Expected HTTP 200 status code');
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
        insert testCustomer;
        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status');
      //  System.assert(responseBody.contains('Your Profile is Successfully Completed.'), 'message');

       

        // End the test
        Test.stopTest();
    }

   
    
}