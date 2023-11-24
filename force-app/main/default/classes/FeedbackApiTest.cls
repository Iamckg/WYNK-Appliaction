@isTest
private class FeedbackApiTest {
    @isTest
    static void testSuccessfulFeedback() {
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
        Password__c = 'testpassword'
        );
        insert testCustomer;


        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/feedback/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '","title":"Test Feedback","description":"This is a test feedback","NotificationId":""}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Feedback_Api.completeProfile(testCustomer.Id, 'Test Feedback', 'This is a test feedback', '');

        // Perform assertions
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status');
        System.assert(responseBody.contains('Your feedback is Successfully Sent.'), 'message');

        // Query the database to ensure that the feedback record is created
        List<Feedback__c> feedbackRecords = [SELECT Id, Name, Description__c, Customer__c FROM Feedback__c WHERE Customer__c = :testCustomer.Id];
        System.assertEquals(1, feedbackRecords.size(), 'One feedback record should exist');
        System.assertEquals('Test Feedback', feedbackRecords[0].Name, 'Feedback title should match');
        System.assertEquals('This is a test feedback', feedbackRecords[0].Description__c, 'Feedback description should match');
        System.assertEquals(testCustomer.Id, feedbackRecords[0].Customer__c, 'Customer should match');

        Test.stopTest();
    }
    
    
     @isTest
    static void testTitleNull() {
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
        Password__c = 'testpassword'
        );
        insert testCustomer;


        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/feedback/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '","title":"","description":"This is a test feedback","NotificationId":""}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Feedback_Api.completeProfile(testCustomer.Id, '', 'This is a test feedback', '');

        // Perform assertions
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status');
        System.assert(responseBody.contains('Your feedback is Successfully Sent.'), 'message');

        // Query the database to ensure that the feedback record is created
        List<Feedback__c> feedbackRecords = [SELECT Id, Name, Description__c, Customer__c FROM Feedback__c WHERE Customer__c = :testCustomer.Id];
        System.assertEquals(1, feedbackRecords.size(), 'One feedback record should exist');
        System.assertEquals('User Feedback', feedbackRecords[0].Name, 'Feedback title should match');
        System.assertEquals('This is a test feedback', feedbackRecords[0].Description__c, 'Feedback description should match');
        System.assertEquals(testCustomer.Id, feedbackRecords[0].Customer__c, 'Customer should match');

        Test.stopTest();
    }

    
    
    @isTest
    static void testFailedFeedback() {
        // Set up the request with missing AccountId
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/feedback/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"invalidAccountId","title":"Test Feedback","description":"This is a test feedback","NotificationId":""}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Feedback_Api.completeProfile('invalidAccountId', 'Test Feedback', 'This is a test feedback', '');

        // Perform assertions
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status');
     //   System.assert(responseBody.contains('Account not found.'), 'message');

        Test.stopTest();
    }

    @isTest
    static void testDeleteNotification() {
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
        Password__c = 'testpassword'
    );
    insert testCustomer;

        // Create a User_Notification__c record
        User_Notification__c notification = new User_Notification__c(Customer__c = testCustomer.Id);
        insert notification;

        // Set up the request to include the NotificationId
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/feedback/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '","title":"Test Feedback","description":"This is a test feedback","NotificationId":"' + notification.Id + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Feedback_Api.completeProfile(testCustomer.Id, 'Test Feedback', 'This is a test feedback', notification.Id);
        
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status');
        System.assert(responseBody.contains('Your feedback is Successfully Sent.'), 'message');

        // Query the database to ensure that the User_Notification__c record is deleted
        List<User_Notification__c> userNotifications = [SELECT Id FROM User_Notification__c WHERE Id = :notification.Id];
        System.assertEquals(0, userNotifications.size(), 'User Notification record should be deleted');

        Test.stopTest();
    }
    
     @isTest
    static void testCatchBlock() {
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
        Password__c = 'testpassword'
    );
   

        // Create a User_Notification__c record
        User_Notification__c notification = new User_Notification__c(Customer__c = testCustomer.Id);
        insert notification;

        // Set up the request to include the NotificationId
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/feedback/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '","title":"Test Feedback","description":"This is a test feedback","NotificationId":"' + notification.Id + '"}');

        // Start the test
        Test.startTest();
        insert testCustomer;
        // Invoke the API method
        Feedback_Api.completeProfile(testCustomer.Id, 'Test Feedback', 'This is a test feedback', notification.Id);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status');
        System.assert(responseBody.contains('Your feedback is Successfully Sent.'), 'message');

        // Query the database to ensure that the User_Notification__c record is deleted
        List<User_Notification__c> userNotifications = [SELECT Id FROM User_Notification__c WHERE Id = :notification.Id];
        System.assertEquals(0, userNotifications.size(), 'User Notification record should be deleted');

        Test.stopTest();
    }
    
    
}