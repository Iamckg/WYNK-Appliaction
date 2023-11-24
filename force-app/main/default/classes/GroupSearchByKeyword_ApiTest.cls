@isTest
public class GroupSearchByKeyword_ApiTest {

    @isTest
    static void testGetLabelList() {
        // Create test data
        Customer__c user = new Customer__c(Name = 'Test User');
        insert user;

        Group__c group1 = new Group__c(Name = 'Test Group 1', Date__c = Date.newInstance(2023, 4, 1), Description__c = 'Description 1', Customer__c = user.Id);
        insert group1;

        Group__c group2 = new Group__c(Name = 'Test Group 2', Date__c = Date.newInstance(2023, 4, 2), Description__c = 'Description 2', Customer__c = user.Id);
        insert group2;

        Group__c group3 = new Group__c(Name = 'Another Group', Date__c = Date.newInstance(2023, 4, 3), Description__c = 'Description 3', Customer__c = user.Id);
        insert group3;

        Group_Member__c groupMember1 = new Group_Member__c(Name = 'Member 1', MemberId__c = user.Id, IsJoined__c = true, Group__c = group1.Id, Declined__c = false);
        insert groupMember1;

        Group_Member__c groupMember2 = new Group_Member__c(Name = 'Member 2', MemberId__c = user.Id, IsJoined__c = true, Group__c = group2.Id, Declined__c = false);
        insert groupMember2;

        Group_Member__c groupMember3 = new Group_Member__c(Name = 'Member 3', MemberId__c = user.Id, IsJoined__c = true, Group__c = group3.Id, Declined__c = false);
        insert groupMember3;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GroupSearchByKeyword';
        request.httpMethod = 'POST';

        // Create a keyword for the request
        String keyword = 'Test';

        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('UserId', user.Id);
        requestBody.put('Keyword', keyword);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Call the API method
        GroupSearchByKeyword_Api.getLabelList(user.Id, keyword);

        Test.stopTest();


        // Clean up test data
        delete groupMember1;
        delete groupMember2;
        delete groupMember3;
        delete group1;
        delete group2;
        delete group3;
        delete user;
    }

    @isTest
    static void testApiErrorHandling() {
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GroupSearchByKeyword';
        request.httpMethod = 'POST';

        // Missing UserId in request body
        Map<String, Object> requestBody = new Map<String, Object>();
        // Comment out or remove the next line to simulate missing UserId
        // requestBody.put('UserId', 'testUserId');
        String keyword = 'Test';
        requestBody.put('Keyword', keyword);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
      // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Call the API method
        GroupSearchByKeyword_Api.getLabelList(null, keyword);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
    }
    // Define a mock class for the HTTP callout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Status": "Success", "GroupList": [{"GroupName": "MockGroup"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
}