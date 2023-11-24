@isTest
private class DeleteAccount_ApiTest {
    @isTest
    static void testDeleteAccount_Success() {
        // Create a test customer record
        Customer__c testCustomer = new Customer__c();
        testCustomer.Name = 'TestUser';
      
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/delete/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        DeleteAccount_Api.deleteAccount(testCustomer.Id);
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status');
        System.assert(responseBody.contains('Account deleted successfully.'), 'message');

        // Query the database to ensure that the record was updated
        Customer__c deletedCustomer = [SELECT Id, IsDeleted__c FROM Customer__c WHERE Id = :testCustomer.Id];
        System.assert(deletedCustomer.IsDeleted__c, 'IsDeleted should be true');

        Test.stopTest();
    }

    @isTest
    static void testDeleteAccount_NotFound() {
        // Set up the request with a non-existing AccountId
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/delete/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"a0B5j0000070uWIEAY"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        DeleteAccount_Api.deleteAccount('a0B5j0000070uWIEAY');
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        Test.stopTest();
    }
     @isTest
    static void testElse() {
        // Create a test customer record
        Customer__c testCustomer = new Customer__c();
        testCustomer.Name = 'TestUser';
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/delete/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' +' testCustomer.Id' + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        DeleteAccount_Api.deleteAccount('testCustomer.Id');
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
        String responseBody = res.responseBody.toString();
      //  System.assert(responseBody.contains('Success'), 'Status');
       // System.assert(responseBody.contains('Account deleted successfully.'), 'message');

        // Query the database to ensure that the record was updated
        Customer__c deletedCustomer = [SELECT Id, IsDeleted__c FROM Customer__c WHERE Id = :testCustomer.Id];
      

        Test.stopTest();
    }
}