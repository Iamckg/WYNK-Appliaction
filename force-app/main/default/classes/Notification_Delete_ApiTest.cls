@isTest
private class Notification_Delete_ApiTest {
    @isTest
    static void testDeleteNotifications_Success() {
        // Create test data
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

        User_Notification__c testNotification = new User_Notification__c(
            Name = 'TestNotification',
            Customer__c = testCustomer.Id
        );
        insert testNotification;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/NotificationDeleteApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '","NotificationId":"' + testNotification.Id + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Notification_Delete_Api.DeleteNotifications(testCustomer.Id, testNotification.Id);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('Your Notification for the User Successfully Deleted'), 'Message');

        // Ensure that the notification has been deleted
        List<User_Notification__c> deletedNotifications = [SELECT Id FROM User_Notification__c WHERE Id = :testNotification.Id];
        System.assertEquals(0, deletedNotifications.size(), 'Notification should be deleted');

        Test.stopTest();
    }

    @isTest
    static void testDeleteNotifications_NotFound() {
        // Create test data
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

        // Set up the request with a non-existing NotificationId
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/NotificationDeleteApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '","NotificationId":"invalidNotificationId"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Notification_Delete_Api.DeleteNotifications(testCustomer.Id, 'invalidNotificationId');

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
  
        Test.stopTest();
    }
}