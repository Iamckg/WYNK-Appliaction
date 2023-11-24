@isTest
public class GroupDelete_ApiTest {
    @isTest
    static void testDeleteGroup() {
        // Create a test user  
        Customer__c testUser = new Customer__c();
        testUser.Name = 'John Doe';
        testUser.Phone__c = '1234567890';
        testUser.IsDeleted__c = false;
        insert testUser;

        // Create a test group owned by the test user
        Group__c testGroup = new Group__c(
            Name = 'Test Group',
            Customer__c = testUser.Id
        );
        insert testGroup;

        // Define the parameters for the API request
        String userId = testUser.Id;
        String groupId = testGroup.Id;

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/GroupDelete';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', userId);
        requestBody.put('GroupId', groupId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);
        
        Test.StartTest();
        GroupDelete_Api.DeleteGroup(userId, groupId);

        // Check the response
        String jsonResponse = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        System.assertEquals('Success', responseMap.get('Status'));

        // Check if the group and related records were deleted
        List<Group__c> deletedGroups = [SELECT Id FROM Group__c WHERE Id = :groupId];
        List<Group_Member__c> deletedMembers = [SELECT Id FROM Group_Member__c WHERE Group__c = :groupId];
        System.assertEquals(0, deletedGroups.size(), 'Group should be deleted');
        System.assertEquals(0, deletedMembers.size(), 'Group members should be deleted');
        Test.stopTest();
    }
    
     @isTest
    static void testcatch() {
        // Create a test user  
        Customer__c testUser = new Customer__c();
        testUser.Name = 'John Doe';
        testUser.Phone__c = '1234567890';
        testUser.IsDeleted__c = false;
        insert testUser;

        // Create a test group owned by the test user
        Group__c testGroup = new Group__c(
            Name = 'Test Group',
            Customer__c = testUser.Id
        );
        insert testGroup;

        // Define the parameters for the API request
        String userId = testUser.Id;
        String groupId = testGroup.Id;

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/GroupDelete';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', 'userId');
        requestBody.put('GroupId', 'groupId');

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);
        
        Test.StartTest();
        GroupDelete_Api.DeleteGroup('userId', 'groupId');

        // Check the response
        String jsonResponse = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);

        Test.stopTest();
    }
    
     @isTest
    static void testelse() {
        // Create a test user  
        Customer__c testUser = new Customer__c();
        testUser.Name = 'John Doe';
        testUser.Phone__c = '1234567890';
        testUser.IsDeleted__c = false;
        insert testUser;

        // Create a test group owned by the test user
        Group__c testGroup = new Group__c(
            Name = 'Test Group',
            Customer__c = testUser.Id
        );
        insert testGroup;

        // Define the parameters for the API request
        String userId = 'testUser.Id';
        String groupId = 'testGroup.Id';

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/GroupDelete';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', userId);
        requestBody.put('GroupId', groupId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);
        
        Test.StartTest();
        GroupDelete_Api.DeleteGroup(userId, groupId);

        // Check the response
        String jsonResponse = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);

        Test.stopTest();
    }
}