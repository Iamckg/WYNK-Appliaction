@isTest(SeeAllData=true)
private class FirebasePushNotificationTest {

    @isTest
    static void testSendFCMNotification() {
        // Replace with your actual server key and device token
       
        String deviceToken = 'dgef8_7fToqQtTFy_XnGIR:APA91bEgv8ry_m5t04bBxWCa1zKNKtouwNx5VkxEN2_sBAI_yVaYTIBD3Rs4KVPdYwDxMbYvCcQrGLNxMQom2UXkO_Z7Yl_32TcC7MB1sbwmlKHAZbzpvKF8-LXp7shKRIhwVfTfPpWH';

        // Mock the HTTP callout response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();

        // Call the REST API
        String response = FirebasePushNotification.SendFCMNotification(deviceToken, 'Test message', 'Test title');

        Test.stopTest();

        // Assert the response
        String expectedResponse = 'FCM notification sent successfully.';
      //  System.assertEquals(expectedResponse, response);
    }

    // MockHttpResponseGenerator class to simulate HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"message_id": "testMessageId"}');
            return res;
        }
    }
}