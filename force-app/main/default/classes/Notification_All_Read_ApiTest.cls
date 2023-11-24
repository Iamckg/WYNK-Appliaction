@isTest
private class Notification_All_Read_ApiTest {
    @isTest
    static void testMarkAllNotificationsAsRead_Success() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

        // Create test notifications
        List<User_Notification__c> testNotifications = new List<User_Notification__c>();
        for (Integer i = 0; i < 5; i++) {
            User_Notification__c notification = new User_Notification__c(Name = 'Notification ' + i, Customer__c = testCustomer.Id, IsRead__c = false );
            testNotifications.add(notification);
        }
        insert testNotifications;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/NotificationAllReadApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '","IsRead":true}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Notification_All_Read_Api.MarkAllNotificationsAsRead(testCustomer.Id, true);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('All Notification is Successfully Marked as Read'), 'Message');

        // Verify that all notifications are marked as read
        List<User_Notification__c> updatedNotifications = [SELECT Id, IsRead__c FROM User_Notification__c WHERE Customer__c = :testCustomer.Id];
        for (User_Notification__c notification : updatedNotifications) {
            System.assertEquals(true, notification.IsRead__c, 'Notification should be marked as read');
        }

        Test.stopTest();
    }

    @isTest
    static void testMarkAllNotificationsAsUnread_Success() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

        // Create test notifications
        List<User_Notification__c> testNotifications = new List<User_Notification__c>();
        for (Integer i = 0; i < 5; i++) {
        User_Notification__c notification = new User_Notification__c(Name = 'Notification ' + i, Customer__c = testCustomer.Id, IsRead__c = true ); 
            testNotifications.add(notification);
        }
        insert testNotifications;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/NotificationAllReadApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '","IsRead":false}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Notification_All_Read_Api.MarkAllNotificationsAsRead(testCustomer.Id, false);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('All Notification is Successfully Marked as Unread'), 'Message');

        // Verify that all notifications are marked as unread
        List<User_Notification__c> updatedNotifications = [SELECT Id, IsRead__c FROM User_Notification__c WHERE Customer__c = :testCustomer.Id];
        for (User_Notification__c notification : updatedNotifications) {
            System.assertEquals(false, notification.IsRead__c, 'Notification should be marked as unread');
        }

        Test.stopTest();
    }
    
        @isTest
        static void testMarkAll_CatchBlock() {
     

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;  
        // Set the request properties
        req.requestURI = '/services/apexrest/NotificationAllReadApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"a005j00000NozBRAAZ" ,"IsRead":true}');
        // Start the test
        Test.startTest();
    
        // Invoke the API method
        Notification_All_Read_Api.MarkAllNotificationsAsRead('a005j00000NozBRAAZ', true);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
  
        Test.stopTest();
    }
}