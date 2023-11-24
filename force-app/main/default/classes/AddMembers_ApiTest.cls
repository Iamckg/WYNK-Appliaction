@isTest
public class AddMembers_ApiTest {

    @isTest
    static void testAddMembers() {
        Customer__c user = new Customer__c(Name = 'User1', Last_Name__c = 'Last1');  
        insert user;
        Group__c testGroup = new Group__c(Name = 'Test Group',Customer__c=user.Id,Date__c=Date.newInstance(2023,10,10));
        insert testGroup;

        Customer__c user1 = new Customer__c(Name = 'User1', Last_Name__c = 'Last1',Phone__c='900000');
        Customer__c user2 = new Customer__c(Name = 'User2', Last_Name__c = 'Last2',Phone__c='900000');
        Customer__c user3 = new Customer__c(Name = 'User3', Last_Name__c = 'Last3',Phone__c='900000');
        insert new List<Customer__c> {user1, user2, user3};

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/AddGroupMembers';
        request.httpMethod = 'POST';

        // Define the parameters for the request
        String groupId = testGroup.Id;
        List<String> memberIds = new List<String> {user1.Id, user2.Id, user3.Id};

        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('GroupId', groupId);
        requestBody.put('MemberIds', memberIds);

        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        AddMembers_Api.AddMembers(groupId, memberIds);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        System.assertEquals('Your Group Members are Successfully Added', result.get('message'));

        // Clean up test data
        delete testGroup;
        delete user1;
        delete user2;
        delete user3;
    }

    @isTest
    static void testApiErrorHandling() {
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/AddGroupMembers';
        request.httpMethod = 'POST';

        // Missing GroupId and MemberIds in the request body
        Map<String, Object> requestBody = new Map<String, Object>();
        // Comment out or remove the next lines to simulate missing GroupId and MemberIds
        // requestBody.put('GroupId', 'testGroupId');
        // requestBody.put('MemberIds', new List<String>());
        
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        AddMembers_Api.AddMembers(null, new List<String>());

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Failed', result.get('Status'));
    }
}