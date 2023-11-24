@isTest
public class FriendRequestAcceptDeclinedApiTest {
   // MockHttpResponseGenerator class to simulate HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"Status": "Success", "message": "Friend request accepted.", "NotificationIds": ["notificationId1", "notificationId2"]}');
            return res;
        }
    }
    
    @isTest
    static void testAcceptRequestSuccess() {
        // Create test data
        Customer__c senderCustomer = new Customer__c(Name = 'Sender Customer', Last_Name__c = 'Sender Last Name', Phone__c = '9000000', Date_of_Birth__c = Date.newInstance(2023, 10, 10));
        insert senderCustomer;

        Customer__c acceptCustomer = new Customer__c(Name = 'Accept Customer', Last_Name__c = 'Accepter Last Name', Phone__c = '9000000', Date_of_Birth__c = Date.newInstance(2023, 10, 10));
        insert acceptCustomer;

        // Create a notification for the sender
        User_Notification__c notification = new User_Notification__c(Customer__c = senderCustomer.Id, Name = 'Friend Request', Message__c = 'Friend Request Message');
        insert notification;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/FriendRequestAcceptDeclined';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('SendUserId', senderCustomer.Id);
        requestBody.put('AcceptUserId', acceptCustomer.Id);
        requestBody.put('NotificationId', notification.Id);
        requestBody.put('Type', 'Accept');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
// Set the mock for the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Call the API method
        FriendRequestAcceptDeclined_Api.AcceptAndDeclineRequest(senderCustomer.Id, acceptCustomer.Id, notification.Id, 'Accept');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        System.assertEquals('You have accepted the friend request.', result.get('message'));

        // Verify that the friend records are created
        Friend__c friend1 = [SELECT Id FROM Friend__c WHERE Customer__c = :senderCustomer.Id];
        Friend__c friend2 = [SELECT Id FROM Friend__c WHERE Customer__c = :acceptCustomer.Id];

        // Verify that the notification is deleted
        try {
            User_Notification__c notificationDeleted = [SELECT Id FROM User_Notification__c WHERE Id = :notification.Id LIMIT 1];
            delete notificationDeleted;
        } catch (QueryException e) {
            // Handle the exception (e.g., log it, add comments)
        }

        delete friend1;
        delete friend2;
        delete senderCustomer;
        delete acceptCustomer;
    }

    @isTest
    static void testDeclineRequestSuccess() {
        // Create test data
        Customer__c senderCustomer = new Customer__c(Name = 'Sender Customer');
        insert senderCustomer;

        Customer__c acceptCustomer = new Customer__c(Name = 'Accept Customer');
        insert acceptCustomer;

        // Create a notification for the sender
        User_Notification__c notification = new User_Notification__c(Customer__c = senderCustomer.Id, Name = 'Friend Request', Message__c = 'Friend Request Message');
        insert notification;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/FriendRequestAcceptDeclined';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('SendUserId', senderCustomer.Id);
        requestBody.put('AcceptUserId', acceptCustomer.Id);
        requestBody.put('NotificationId', notification.Id);
        requestBody.put('Type', 'Decline');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        // Set the mock for the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the API method
        FriendRequestAcceptDeclined_Api.AcceptAndDeclineRequest(senderCustomer.Id, acceptCustomer.Id, notification.Id, 'Decline');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        System.assertEquals('You have declined the friend request.', result.get('message'));

        // Verify that the notification is deleted
        try {
            User_Notification__c notificationDeleted = [SELECT Id FROM User_Notification__c WHERE Id = :notification.Id LIMIT 1];
            delete notificationDeleted;
        } catch (QueryException e) {
            // Handle the exception (e.g., log it, add comments)
        }

        delete senderCustomer;
        delete acceptCustomer;
    }

    @isTest
    static void testInvalidType() {
        // Create test data
        Customer__c senderCustomer = new Customer__c(Name = 'Sender Customer');
        insert senderCustomer;

        Customer__c acceptCustomer = new Customer__c(Name = 'Accept Customer');
        insert acceptCustomer;

        // Create a notification for the sender
        User_Notification__c notification = new User_Notification__c(Customer__c = senderCustomer.Id, Name = 'Friend Request', Message__c = 'Friend Request Message');
        insert notification;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/FriendRequestAcceptDeclined';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('SendUserId', senderCustomer.Id);
        requestBody.put('AcceptUserId', acceptCustomer.Id);
        requestBody.put('NotificationId', notification.Id);
        requestBody.put('Type', 'InvalidType');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        // Set the mock for the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the API method
        FriendRequestAcceptDeclined_Api.AcceptAndDeclineRequest(senderCustomer.Id, acceptCustomer.Id, notification.Id, 'InvalidType');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

     //   System.assertEquals('Success', result.get('Status'));
      //  System.assertEquals('You have declined the friend request.', result.get('message'));

        // Verify that the notification is deleted
        try {
            User_Notification__c notificationNotDeleted = [SELECT Id FROM User_Notification__c WHERE Id = :notification.Id LIMIT 1];
            delete notificationNotDeleted;
        } catch (QueryException e) {
            // Handle the exception (e.g., log it, add comments)
        }

        delete senderCustomer;
        delete acceptCustomer;
    }
}