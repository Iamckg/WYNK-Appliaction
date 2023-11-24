@isTest
public class GroupEdit_ApiTest {
// MockHttpResponseGenerator class to simulate HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"Status": "Success", "message": "Group updated successfully."}');
            return res;
        }
    }
    @isTest
    static void testEditGroup() {
        // Create test data
        Customer__c user = new Customer__c(Name = 'Test User', Last_Name__c = 'TestLast');
        insert user;

        Group__c testGroup = new Group__c(
            Name = 'Original Group Name',
            Customer__c = user.Id,
            Date__c = Date.newInstance(2023, 4, 15),
            Description__c = 'Original Group Description'
        );
        insert testGroup;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GroupEdit';
        request.httpMethod = 'POST';

        // Define the parameters for the request
        String groupId = testGroup.Id;
        String newTitle = 'New Group Name';
        String newDescription = 'New Group Description';
         String ImageUrl = 'https://b2btobacco.s3.amazonaws.com/moh9.jpeg';
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('GroupId', groupId);
        requestBody.put('title', newTitle);
        requestBody.put('GroupDate', '2023-05-01');
        requestBody.put('Description', newDescription);
        requestBody.put('ImageUrl', ImageUrl);
        
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Call the API method
        GroupEdit_Api.CreateGroup(groupId, newTitle, '2023-05-01', newDescription,ImageUrl);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        System.assertEquals(newTitle, result.get('Name'));
        System.assertEquals('2023-05-01', result.get('GroupDate'));
        System.assertEquals(newDescription, result.get('Description'));
        System.assertEquals(groupId, result.get('AccountId'));
        System.assertEquals('Your Group is Successfully Created.', result.get('message'));

        // Clean up test data
        // Delete the updated group
        delete [SELECT Id FROM Group__c WHERE Id = :groupId];

        // Delete the user
        delete user;
    }

    @isTest
    static void testApiErrorHandling() {
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GroupEdit';
        request.httpMethod = 'POST';

        // Missing GroupId in request body
        Map<String, Object> requestBody = new Map<String, Object>();
        // Comment out or remove the next line to simulate missing GroupId
        // requestBody.put('GroupId', 'testGroupId');
        requestBody.put('title', 'New Title');
        requestBody.put('GroupDate', '2023-05-01');
        requestBody.put('Description', 'New Description');
        requestBody.put ('ImageUrl' ,'https://b2btobacco.s3.amazonaws.com/moh9.jpeg');
        
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Call the API method
        GroupEdit_Api.CreateGroup(null, 'New Title', '2023-05-01', 'New Description','ImageUrl');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Failed', result.get('Status'));
    }
}