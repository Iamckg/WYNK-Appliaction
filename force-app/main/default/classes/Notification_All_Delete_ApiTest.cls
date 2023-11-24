@isTest
private class Notification_All_Delete_ApiTest {
    @isTest
    static void testDeleteNotifications_Success() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

        // Create test notifications
        List<User_Notification__c> testNotifications = new List<User_Notification__c>();
        for (Integer i = 0; i < 5; i++) {
            User_Notification__c notification = new User_Notification__c(
                Name = 'Notification ' + i,
                Customer__c = testCustomer.Id
            );
            testNotifications.add(notification);
        }
        insert testNotifications;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/NotificationAllDeleteApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Notification_All_Delete_Api.DeleteNotifications(testCustomer.Id);

   
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('All Notifications for the User Successfully Deleted'), 'Notification deletion message');

        // Ensure that notifications are deleted
        List<User_Notification__c> remainingNotifications = [SELECT Id FROM User_Notification__c WHERE Customer__c = :testCustomer.Id];
        System.assertEquals(0, remainingNotifications.size(), 'All notifications should be deleted');

        Test.stopTest();
    }

    @isTest
    static void testDeleteNotifications_NoNotifications() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/NotificationAllDeleteApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Notification_All_Delete_Api.DeleteNotifications(testCustomer.Id);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('No Notifications found for the User'), 'No notifications message');

        Test.stopTest();
    }
    @isTest
    static void testcatch() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

        // Create test notifications
        List<User_Notification__c> testNotifications = new List<User_Notification__c>();
        for (Integer i = 0; i < 5; i++) {
            User_Notification__c notification = new User_Notification__c(
              
                Customer__c = testCustomer.Id
            );
            testNotifications.add(notification);
        }
        insert testNotifications;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/NotificationAllDeleteApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Notification_All_Delete_Api.DeleteNotifications(testCustomer.Id);

   
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('All Notifications for the User Successfully Deleted'), 'Notification deletion message');

        // Ensure that notifications are deleted
        List<User_Notification__c> remainingNotifications = [SELECT Id FROM User_Notification__c WHERE Customer__c = :testCustomer.Id];
        System.assertEquals(0, remainingNotifications.size(), 'All notifications should be deleted');

        Test.stopTest();
    }

}