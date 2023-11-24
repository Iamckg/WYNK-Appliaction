@isTest
public class GroupMembersLeave_ApiTest {
    @isTest
    static void testLeaveGroup() {
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

        // Add a test member to the group
        Group_Member__c testMember = new Group_Member__c(
            MemberId__c = testUser.Id,
            Group__c = testGroup.Id
        );
        insert testMember;

        // Define the parameters for the API request
        String memberId = testUser.Id;
        String groupId = testGroup.Id;

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/GroupMembersLeave';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('MemberId', memberId);
        requestBody.put('GroupId', groupId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);
        Test.startTest();
        // Call the REST API
        GroupMembersLeave_Api.LeaveGroup(groupId, memberId);

        // Check the response
        String jsonResponse = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);

        // Assert that the API call was successful
        System.assertEquals('Success', responseMap.get('Status'));

        // Check if the group member was deleted
        List<Group_Member__c> deletedMembers = [SELECT Id FROM Group_Member__c WHERE Id = :testMember.Id];

        Test.stopTest();
    }
    
    @isTest
    static void testCatch() {
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

        // Add a test member to the group
        Group_Member__c testMember = new Group_Member__c(
            MemberId__c = testUser.Id,
            Group__c = testGroup.Id
        );
        insert testMember;

        // Define the parameters for the API request
        String memberId = testUser.Id;
        String groupId = testGroup.Id;

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/GroupMembersLeave';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('MemberId', 'memberId');
        requestBody.put('GroupId', 'groupId');

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);
        Test.startTest();
        // Call the REST API
        GroupMembersLeave_Api.LeaveGroup('groupId', 'memberId');

        // Check the response
        String jsonResponse = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);



        Test.stopTest();
    }
}