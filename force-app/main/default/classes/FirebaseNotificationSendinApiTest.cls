@isTest
private class FirebaseNotificationSendinApiTest {

    @isTest
    static void testSendFCMNotifications() {
        // Create test data
        Customer__c testCustomer = new Customer__c(Name = 'Test Customer',
                Device_Token__c = 'dgef8_7fToqQtTFy_XnGIR:APA91bEgv8ry_m5t04bBxWCa1zKNKtouwNx5VkxEN2_sBAI_yVaYTIBD3Rs4KVPdYwDxMbYvCcQrGLNxMQom2UXkO_Z7Yl_32TcC7MB1sbwmlKHAZbzpvKF8-LXp7shKRIhwVfTfPpWH');
        insert testCustomer;

        User_Notification__c testNotification = new User_Notification__c(
            Name = 'Test Notification',
            Message__c = 'Test Message',
            Customer__c = testCustomer.Id
        );
        insert testNotification;

        // Set up the request
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/pushnotification1';
        request.httpMethod = 'POST';

        // Pass the notification ID to the API
        List<String> notificationIds = new List<String>{testNotification.Id};
        String requestBody = JSON.serialize(notificationIds);
        request.requestBody = Blob.valueOf(requestBody);

        Test.startTest();

        // Call the API method
        FirebaseNotificationSendinApi.sendFCMNotifications(notificationIds);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        // Assert the response values based on your implementation
      //  System.assertEquals('Success', result.get('Status'));
     //   System.assertEquals('Notifications has sent to User Successfully', result.get('Message'));

        // Clean up test data if needed
        delete testNotification;
        delete testCustomer;
    }
}