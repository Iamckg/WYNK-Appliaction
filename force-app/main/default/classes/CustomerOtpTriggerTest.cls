@isTest
public class CustomerOtpTriggerTest {

    // Define a mock class for the HTTP callout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
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
    static void testTriggerLogic() {
        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Create a test Customer record
        Customer__c testCustomer = new Customer__c(
            Name = 'Test Customer',
            Phone__c = '1234567890'
            // Add other required fields here
        );
        insert testCustomer;

        // Verify that the OTP field is populated before insert
    //    System.assertNotEquals(null, testCustomer.OTP__c);

        // Verify that the WhatsApp message is sent after insert
        Test.startTest();
        // Perform any additional operations or queries to ensure the WhatsApp message is sent
        Test.stopTest();

        // Add assertions as needed
        // Example: System.assertEquals(expectedValue, actualValue);
    }
}