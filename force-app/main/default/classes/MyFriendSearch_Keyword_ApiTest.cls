@isTest
public class MyFriendSearch_Keyword_ApiTest {
     // Define a mock class for the HTTP callout
    private class MyWebServiceMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": "success", "message": "Mock response"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testFriendSearch() {
        // Create test data
        Customer__c user = new Customer__c(Name = 'Test User');
        insert user;
        Label__c  label = new Label__c (Name='Test Label');
        insert label;
        
        Friend__c friend1 = new Friend__c(
            FirstName__c = 'John',
            Last_Name__c = 'Doe',
            Phone__c = '123-456-7890',
            Label__c = label.Id,
            Customer__c = user.Id
        );
        insert friend1;

        Friend__c friend2 = new Friend__c(
            FirstName__c = 'Jane',
            Last_Name__c = 'Smith',
            Phone__c = '987-654-3210',
            Label__c = label.Id,
            Customer__c = user.Id
        );
        insert friend2;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/MyFriendSearchKeyword';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', user.Id);
        requestBody.put('Keyword', 'John'); // Search for friends with 'John' in their names
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        // Call the API method
        MyFriendSearch_Keyword_Api.MyfriendList(user.Id, 'John');

        Test.stopTest();

      

        // Clean up test data
        delete friend1;
        delete friend2;
        delete user;
    }

    @isTest
    static void testNoFriendsFound() {
        // Create test data
        Customer__c user = new Customer__c(Name = 'Test User');
        insert user;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/MyFriendSearchKeyword';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', user.Id);
        requestBody.put('Keyword', 'NonExistentName'); // Search for friends with a name that doesn't exist
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
       Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        // Call the API method
        MyFriendSearch_Keyword_Api.MyfriendList(user.Id, 'NonExistentName');

        Test.stopTest();

       
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

        request.requestURI = '/services/apexrest/MyFriendSearchKeyword';
        request.httpMethod = 'POST';

        // Missing UserId in request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('Keyword', 'John');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
     Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        // Call the API method
        MyFriendSearch_Keyword_Api.MyfriendList(null, 'John');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
    }
}