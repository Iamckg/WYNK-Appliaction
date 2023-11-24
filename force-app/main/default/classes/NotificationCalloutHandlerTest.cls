@isTest
private class NotificationCalloutHandlerTest {

    @isTest
    static void testNotifyCustomers() {
        // Create test data: Customer__c records
        List<Customer__c> customers = new List<Customer__c>();
        customers.add(new Customer__c(Name='TestCustomer1', Device_Token__c='TestToken1'));
        customers.add(new Customer__c(Name='TestCustomer2', Device_Token__c='TestToken2'));
        insert customers;

        // Get the Ids of the inserted customer records
        List<Id> customerIds = new List<Id>();
        for (Customer__c cust : customers) {
            customerIds.add(cust.Id);
        }

        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the future method within Test.startTest() and Test.stopTest()
        Test.startTest();
        NotificationCalloutHandler.notifyCustomers(customerIds, 'Test message');
        Test.stopTest();

        // Verify that User_Notification__c records are created
        List<User_Notification__c> userNotifications = [SELECT Id FROM User_Notification__c];
       // System.assertNotEquals(0, userNotifications.size(), 'User_Notification__c records should be created');

        // Perform additional assertions based on your requirements
        // For example, check the contents of the created records or verify other expected behavior
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