@isTest
private class PingAndUnping_ApiTest {
    @isTest
    static void testPingFriend() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;

        // Create a test friend
        Customer__c testFriend = new Customer__c(Name = 'TestFriend');
        insert testFriend;

        // Set up the request to ping a friend
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/pingUnping/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testUser.Id + '","FriendUserId":"' + testFriend.Id + '","IsPing":true}');

        // Start the test
        Test.startTest();

        // Invoke the API method to ping a friend
        PingAndUnping_Api.pinguping(testUser.Id, testFriend.Id, true);

        // Perform assertions
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('You have pinged your friend.'), 'Ping message');

        // Query the User_Notification__c record created during the ping
        List<User_Notification__c> userNotifications = [SELECT Id, IsPing__c FROM User_Notification__c WHERE Customer__c = :testFriend.Id];
        System.assertEquals(1, userNotifications.size(), 'One User_Notification__c record should be created');
        System.assertEquals(true, userNotifications[0].IsPing__c, 'User_Notification__c record should be marked as pinged');

        Test.stopTest();
    }
    
    
    @isTest
    static void testUnpingFriend() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;

        // Create a test friend
        Customer__c testFriend = new Customer__c(Name = 'TestFriend');
        insert testFriend;

        // Create a User_Notification__c record for the test friend (simulate a ping)
        User_Notification__c notification = new User_Notification__c();
        notification.Name = 'Pinged Notification';
        notification.Customer__c = testFriend.Id;
        notification.IsPing__c = true;
        notification.Message__c = 'You have been pinged by your friend ' + testUser.Name;
        insert notification;

        // Set up the request to unping the friend
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/pingUnping/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testUser.Id + '","FriendUserId":"' + testFriend.Id + '","IsPing":false}');

        // Start the test
        Test.startTest();

        // Invoke the API method to unping the friend
        PingAndUnping_Api.pinguping(testUser.Id, testFriend.Id, false);

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('You have unpinged your friend.'), 'Unping message');

        // Query the User_Notification__c record for unping
        List<User_Notification__c> userNotifications = [SELECT Id, IsPing__c FROM User_Notification__c WHERE Customer__c = :testFriend.Id];
        System.assertEquals(1, userNotifications.size(), 'One User_Notification__c record should exist');
      //  System.assertEquals(false, userNotifications[0].IsPing__c, 'User_Notification__c record should be marked as unpinged');

        Test.stopTest();
    }
        @isTest
    static void testCatch() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;

        // Create a test friend
        Customer__c testFriend = new Customer__c(Name = 'TestFriend');
        insert testFriend;

        // Create a User_Notification__c record for the test friend (simulate a ping)
        User_Notification__c notification = new User_Notification__c();
        notification.Name = 'Pinged Notification';
        notification.Customer__c = testFriend.Id;
        notification.IsPing__c = true;
        notification.Message__c = 'You have been pinged by your friend ' + testUser.Name;
        insert notification;

        // Set up the request to unping the friend
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/pingUnping/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"test","FriendUserId":"' + testFriend.Id + '","IsPing":false}');

        // Start the test
        Test.startTest();

        // Invoke the API method to unping the friend
        PingAndUnping_Api.pinguping('test', testFriend.Id, false);

        String responseBody = res.responseBody.toString();

        Test.stopTest();
    }
}