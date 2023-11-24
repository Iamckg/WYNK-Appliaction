@isTest
public class UserByLabelTest {
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
    static void testWithLabelId() {
        // Create test data
        Customer__c customer = new Customer__c(Name = 'John Doe');
        Label__c label = new Label__c(Name = 'Test Label');
        insert label;
        customer.Label__c = label.Id;
        insert customer;

        Friend__c friend = new Friend__c(Name = 'Friend 1', FirstName__c = 'First', Last_Name__c = 'Last', Customer__c = customer.Id, Label__c = label.Id);
        insert friend;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/CalendarUserListByLabel';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', customer.Id);
        requestBody.put('LabelId', label.Id);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        // Call the API method
        User_By_label.getLabelList(customer.Id, label.Id);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));

        List<Object> friendsList = (List<Object>) result.get('FriendsList');
        System.assertEquals(1, friendsList.size());

        // Clean up test data
        delete friend;
        delete customer;
        delete label;
    }

    @isTest
    static void testWithoutLabelId() {
        // Create test data
        Customer__c customer = new Customer__c(Name = 'John Doe');
        Label__c label = new Label__c(Name = 'Test Label');
        insert label;
        customer.Label__c = label.Id;
        insert customer;

        Friend__c friend = new Friend__c(Name = 'Friend 1', FirstName__c = 'First', Last_Name__c = 'Last', Customer__c = customer.Id, Label__c = label.Id);
        insert friend;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/CalendarUserListByLabel';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', customer.Id);
        // LabelId not provided in this case
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        // Call the API method
        User_By_label.getLabelList(customer.Id, null);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));

        List<Object> friendsList = (List<Object>) result.get('FriendsList');
        System.assertEquals(1, friendsList.size());

        // Clean up test data
        delete friend;
        delete customer;
        delete label;
    }
        @isTest
    static void testCatch() {
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/CalendarUserListByLabel';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', 'test');
        requestBody.put('LabelId', 'test');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        // Call the API method
        User_By_label.getLabelList('', '');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

    }

    
}