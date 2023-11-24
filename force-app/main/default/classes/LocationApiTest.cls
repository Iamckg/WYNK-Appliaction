@isTest
private class LocationApiTest {

    // MockHttpResponseGenerator class to simulate HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"Status": "Success", "message": "Profile completed successfully."}');
            return res;
        }
    }

    @isTest
    static void testCompleteProfile() {
        // Create a test customer record
        Customer__c testCustomer = new Customer__c(
            // ... (your test data)
        );
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/Loaction/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '","country":"USA","state":"CA","city":"San Francisco","CountyFlag":"ABC"}');

        // Start the test
        Test.startTest();

        // Set the mock for the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Invoke the API method
        LocationApi.completeProfile(testCustomer.Id, 'USA', 'CA', 'San Francisco', 'ABC');

    //    System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
     //   System.assert(responseBody.contains('Success'), 'Status');
     //   System.assert(responseBody.contains('Profile completed successfully.'), 'message');

        // Add more assertions if needed

        Test.stopTest();
    }

    // Add similar methods for other scenarios (failed profile completion, etc.)
}