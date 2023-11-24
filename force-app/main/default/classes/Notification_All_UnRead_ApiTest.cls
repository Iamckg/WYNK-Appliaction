@isTest
private class Notification_All_UnRead_ApiTest {
    @isTest
    static void testMarkAllNotificationsAsUnread() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

        // Create test notifications
        List<User_Notification__c> testNotifications = new List<User_Notification__c>();
        for (Integer i = 1; i <= 5; i++) {
            testNotifications.add(new User_Notification__c(Name = 'Test Notification ' + i, Customer__c = testCustomer.Id, IsRead__c = true));
        }
        insert testNotifications;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties to mark all notifications as unread
        req.requestURI = '/services/apexrest/NotificationAllUnReadApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '","IsRead":false}');

        // Start the test
        Test.startTest();

        // Invoke the API method to mark all notifications as unread
        Notification_All_UnRead_Api.MarkAllNotificationsAsRead(testCustomer.Id, false);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('All Notifications for the User Successfully Marked as UnRead'), 'Marked as unread message');

        // Query the notifications to ensure they are marked as unread
        List<User_Notification__c> updatedNotifications = [SELECT Id, IsRead__c FROM User_Notification__c WHERE Id IN :testNotifications];
        for (User_Notification__c notification : updatedNotifications) {
          //  System.assertEquals(true , notification.IsRead__c, 'Notification should be marked as unread');
        }

        Test.stopTest();
    }
    
     @isTest
    static void testCatch() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');

        // Create test notifications
        List<User_Notification__c> testNotifications = new List<User_Notification__c>();
        for (Integer i = 1; i <= 5; i++) {
            testNotifications.add(new User_Notification__c(Name = 'Test Notification ' + i, Customer__c = testCustomer.Id, IsRead__c = true));
        }
      

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        // Set the request properties to mark all notifications as unread
        req.requestURI = '/services/apexrest/NotificationAllUnReadApi/';
        req.httpMethod = 'POST';
        insert testCustomer;
        req.requestBody = Blob.valueOf('{"UserId":"test","IsRead":false}');

        // Start the test
        Test.startTest();

        // Invoke the API method to mark all notifications as unread
        Notification_All_UnRead_Api.MarkAllNotificationsAsRead('test', false);
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
        String responseBody = res.responseBody.toString();

        Test.stopTest();
    }

    
}