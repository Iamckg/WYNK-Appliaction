@isTest
private class GroupCreate_ApiTest {

    @isTest
    static void testCreateGroup() {
        // Create test data
        Customer__c user = new Customer__c(Name = 'Test User');
        insert user;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/Group';
        request.httpMethod = 'POST';

        // Define the parameters for the request
        String title = 'Test Group';
        String groupDate = '2023-04-15'; // Specify a valid date in the format yyyy-MM-dd
        String description = 'Test Description';
        String ImageUrl = 'https://b2btobacco.s3.amazonaws.com/moh9.jpeg';

        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('UserId', user.Id);
        requestBody.put('title', title);
        requestBody.put('GroupDate', groupDate);
        requestBody.put('Description', description);
        requestBody.put('ImageUrl', ImageUrl);

        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        // Use a mock class to simulate a successful response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();

        // Call the API method
        GroupCreate_Api.CreateGroup(user.Id, title, groupDate, description,ImageUrl);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        System.assertEquals(description, result.get('Description'));
        System.assertEquals(groupDate, result.get('GroupDate'));
        System.assertEquals(title, result.get('Name'));

        // Clean up test data
        delete user;
    }

    @isTest
    static void testApiErrorHandling() {
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/Group';
        request.httpMethod = 'POST';

        // Missing UserId in request body
        Map<String, Object> requestBody = new Map<String, Object>();
        // Comment out or remove the next line to simulate missing UserId
        // requestBody.put('UserId', 'testUserId');
        String title = 'Test Group';
        String groupDate = '2023-04-15';
        String description = 'Test Description';
        String ImageUrl = 'https://b2btobacco.s3.amazonaws.com/moh9.jpeg';
        requestBody.put('title', title);
        requestBody.put('GroupDate', groupDate);
        requestBody.put('Description', description);
        requestBody.put('ImageUrl', ImageUrl);

        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        // Use a mock class to simulate an error response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWithError());

        Test.startTest();

        // Call the API method
        GroupCreate_Api.CreateGroup(null, title, groupDate, description, ImageUrl);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        // Verify that the response indicates an error
        System.assertEquals('Failed', result.get('Status'));
    }

    // Mock class that simulates a successful response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            Map<String, Object> responseBody = new Map<String, Object>();
            responseBody.put('ImageUrl', 'https://example.com/image.jpg');
            responseBody.put('Description', 'Test Description');
            responseBody.put('GroupDate', '2023-04-15');
            responseBody.put('Name', 'Test Group');
            responseBody.put('AccountId', '001XXXXXXXXXXXXXXX');
            responseBody.put('message', 'Your Group is Successfully Created.');
            responseBody.put('Status', 'Success');
            res.setBody(JSON.serialize(responseBody));
            return res;
        }
    }

    // Mock class that simulates an error response
    private class MockHttpResponseGeneratorWithError implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500); // Simulate an internal server error
            Map<String, Object> responseBody = new Map<String, Object>();
            responseBody.put('Status', 'Failed');
            responseBody.put('message', 'Simulated error');
            res.setBody(JSON.serialize(responseBody));
            return res;
        }
    }
}