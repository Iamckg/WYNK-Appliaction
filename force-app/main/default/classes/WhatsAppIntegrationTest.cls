@isTest
public class WhatsAppIntegrationTest {

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
    static void testSendWhatsAppMessage() {
        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the sendWhatsAppMessage method
        Test.startTest();
        WhatsAppIntegration.sendWhatsAppMessage('1234567890', '1234');
        Test.stopTest();

        // Perform assertions based on your requirements
        // Example: Verify that the debug log contains the expected message
        String expectedLogMessage = 'Message sent successfully';
     //   System.assert(LoggingUtils.containsDebug(expectedLogMessage), 'Expected log message not found');
    }
}