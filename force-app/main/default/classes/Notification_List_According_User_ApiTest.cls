@isTest
private class Notification_List_According_User_ApiTest {
    @isTest
    static void testGetNotificationList_Success() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

        // Create test notifications
        List<User_Notification__c> testNotifications = new List<User_Notification__c>();
        for (Integer i = 0; i < 5; i++) {
            User_Notification__c notification = new User_Notification__c(Name = 'Notification ' + i, Customer__c = testCustomer.Id, SendFeedback__c = false,  CustomId__c = 'Sender ' + i,
                Message__c = 'Test Message ' + i, IsRead__c = false );
            testNotifications.add(notification);
        }
        insert testNotifications;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/NoticationListAccordingUser/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Notification_List_According_User_Api.CreateGroup(testCustomer.Id);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');

        // Verify that the response contains notification data
        for (User_Notification__c notification : testNotifications) {
            System.assert(responseBody.contains(notification.SendFeedback__c ? 'true' : 'false'), 'SendFeedback');
            System.assert(responseBody.contains(notification.CustomId__c), 'SenderId');
            System.assert(responseBody.contains(notification.Message__c), 'Message');
            System.assert(responseBody.contains(notification.IsRead__c ? 'true' : 'false'), 'IsRead');
            System.assert(responseBody.contains(notification.Name), 'Title');
            System.assert(responseBody.contains(notification.Id), 'NotificationId');
        }

        Test.stopTest();
    }

    @isTest
    static void testGetNotificationList_Empty() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/NoticationListAccordingUser/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Notification_List_According_User_Api.CreateGroup(testCustomer.Id);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
 
        Test.stopTest();
    }
    
    
    @isTest
    static void testGetNotificationList_Catch() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(Name = 'TestUser');
         insert testCustomer;

        // Create test notifications
        List<User_Notification__c> testNotifications = new List<User_Notification__c>();
        for (Integer i = 0; i < 5; i++) {
            User_Notification__c notification = new User_Notification__c(Name = 'Notification ' + i, Customer__c = testCustomer.Id, SendFeedback__c = false,  CustomId__c = 'Sender ' + i,
                Message__c = 'Test Message ' + i, IsRead__c = false );
            testNotifications.add(notification);
            
        }
      
  insert testNotifications;        
        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
      
        // Set the request properties
        req.requestURI = '/services/apexrest/NoticationListAccordingUser/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        Notification_List_According_User_Api.CreateGroup(testCustomer.Id);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();

        Test.stopTest();
    }

    
}