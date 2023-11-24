@isTest
public class MyFriends_Delete_ApiTest {
    @isTest
    static void testDeleteFriendSuccess() {
        Customer__c UserI = new Customer__c(Name = 'firstCustomer',Last_Name__c = 'LastnameCustomer');
        insert UserI;
        // Create a test Label record
        Label__c testLabel = new Label__c(Name = 'TestLabel', Customer__c =UserI.Id);
        insert testLabel;
        Customer__c testCustomer = new Customer__c(Name = 'Friend First Name',Last_Name__c = 'Friend Last Name');
        insert testCustomer;
      
        Friend__c testFriend = new Friend__c( Name = testCustomer.Id,  Label__c = testLabel.Id, FirstName__c = testCustomer.Name ,Last_Name__c = testCustomer.Last_Name__c , Customer__c =UserI.Id);
        insert testFriend;
        Friend__c testFriend1 = new Friend__c( Name = UserI.Id,  FirstName__c = UserI.Name ,Last_Name__c = UserI.Last_Name__c , Customer__c =testCustomer.Id);
        insert testFriend1;

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/MyFriendDelete';
        req.httpMethod = 'POST';

        // Define input parameters
        String memberId = testCustomer.Id;
        String userId = UserI.Id;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('MemberId', memberId);
        requestBody.put('UserId', userId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test the POST request
        Test.startTest();
        MyFriends_Delete_Api.MyfriendList(memberId, userId);
        Test.stopTest();

        // Verify the response
        String responseBody = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        // Perform assertions to validate the response
        System.assertEquals('Success', responseMap.get('Status'));
        System.assertEquals('Your friend is successfully deleted.', responseMap.get('message'));
    }

    @isTest
    static void testDeleteFriendFailureFriendNotFound() {
        Customer__c UserI = new Customer__c(Name = 'firstCustomer',Last_Name__c = 'LastnameCustomer');
        insert UserI;
        // Create a test Label record
        Label__c testLabel = new Label__c(Name = 'TestLabel', Customer__c =UserI.Id);
        insert testLabel;
        Customer__c testCustomer = new Customer__c(Name = 'Friend First Name',Last_Name__c = 'Friend Last Name');
        insert testCustomer;
      
        Friend__c testFriend = new Friend__c( Name = testCustomer.Id,  Label__c = testLabel.Id, FirstName__c = testCustomer.Name ,Last_Name__c = testCustomer.Last_Name__c , Customer__c =UserI.Id);
        insert testFriend;

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/MyFriendDelete';
        req.httpMethod = 'POST';

        // Define input parameters with an invalid memberId
        String memberId = 'invalidId';
        String userId = 'UserI.Id';

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('MemberId', memberId);
        requestBody.put('UserId', userId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test the POST request
        Test.startTest();
        MyFriends_Delete_Api.MyfriendList(memberId, userId);
        Test.stopTest();

        // Verify the response
        // Perform assertions to validate the response (e.g., check that the Status is 'Failed' and the message indicates "Friend not found.")
    }

    @isTest
    static void testDeleteFriendFailureSameMemberIdAndUserId() {
       Customer__c UserI = new Customer__c(Name = 'firstCustomer',Last_Name__c = 'LastnameCustomer');
        insert UserI;
        // Create a test Label record
        Label__c testLabel = new Label__c(Name = 'TestLabel', Customer__c =UserI.Id);
        insert testLabel;
        Customer__c testCustomer = new Customer__c(Name = 'Friend First Name',Last_Name__c = 'Friend Last Name');
        insert testCustomer;
      
        Friend__c testFriend = new Friend__c( Name = testCustomer.Id,  Label__c = testLabel.Id, FirstName__c = testCustomer.Name ,Last_Name__c = testCustomer.Last_Name__c , Customer__c =UserI.Id);
        insert testFriend;

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/MyFriendDelete';
        req.httpMethod = 'POST';

        // Define input parameters with the same memberId and userId
        String memberId = testCustomer.Id;
        String userId = UserI.Id;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('MemberId', memberId);
        requestBody.put('UserId', userId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test the POST request
        Test.startTest();
        MyFriends_Delete_Api.MyfriendList(memberId, userId);
        Test.stopTest();

        // Verify the response
        // Perform assertions to validate the response (e.g., check that the Status is 'Failed' and the message indicates "Friend not found.")
    }
}