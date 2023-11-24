@isTest
private class Notification_Read_UnRead_ApiTest {
    @isTest
    static void testMarkNotificationAsRead() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

        // Create a test notification
        User_Notification__c testNotification = new User_Notification__c(
            Name = 'Test Notification',
            Customer__c = testCustomer.Id
        );
        insert testNotification;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties to mark a notification as read
        req.requestURI = '/services/apexrest/NotificationReadUnReadApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '","NotificationId":"' + testNotification.Id + '","IsRead":true}');

        // Start the test
        Test.startTest();

        // Invoke the API method to mark the notification as read
        Notification_Read_UnRead_Api.MarkNotificationReadUnread(testCustomer.Id, testNotification.Id, true);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('Your Notification is Successfully Marked as Read'), 'Marked as read message');

        // Query the notification to ensure it is marked as read
        User_Notification__c updatedNotification = [SELECT Id, IsRead__c FROM User_Notification__c WHERE Id = :testNotification.Id];
  

        Test.stopTest();
    }

    @isTest
    static void testMarkNotificationAsUnread() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

        // Create a test notification
        User_Notification__c testNotification = new User_Notification__c(
            Name = 'Test Notification',
            Customer__c = testCustomer.Id,
            IsRead__c = true
        );
        insert testNotification;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties to mark a notification as unread
        req.requestURI = '/services/apexrest/NotificationReadUnReadApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '","NotificationId":"' + testNotification.Id + '","IsRead":false}');

        // Start the test
        Test.startTest();

        // Invoke the API method to mark the notification as unread
        Notification_Read_UnRead_Api.MarkNotificationReadUnread(testCustomer.Id, testNotification.Id, false);


        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('Your Notification is Successfully Marked as Unread'), 'Marked as unread message');

        // Query the notification to ensure it is marked as unread
        User_Notification__c updatedNotification = [SELECT Id, IsRead__c FROM User_Notification__c WHERE Id = :testNotification.Id];
    

        Test.stopTest();
    }
    
      @isTest
    static void testMarkNotif() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

   

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties to mark a notification as unread
        req.requestURI = '/services/apexrest/NotificationReadUnReadApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '","NotificationId":"invite","IsRead":false}');

        // Start the test
        Test.startTest();

        // Invoke the API method to mark the notification as unread
        Notification_Read_UnRead_Api.MarkNotificationReadUnread(testCustomer.Id,'test', false);


        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
    

        // Query the notification to ensure it is marked as unread
     

        Test.stopTest();
    }
    
    
    
     @isTest
    static void testElseBlock() {  
        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        // Set the request properties to mark a notification as read
        req.requestURI = '/services/apexrest/NotificationReadUnReadApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"a005j00000R5bktAAB","a005j00bktAAB":"jadu","IsRead":true}');
        
        // Start the test
        Test.startTest();
        // Invoke the API method to mark the notification as read
        Notification_Read_UnRead_Api.MarkNotificationReadUnread('a005j00000R5bktAAB', 'a005j00bktAAB', true);
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
        String responseBody = res.responseBody.toString();
        Test.stopTest();
    }
}