@isTest
private class NameEmailApiTest {

    @isTest
    static void testCompleteProfile_Success() {
        // Create test data
        Customer__c testCustomer = new Customer__c(
            Name = 'TestUser',
            Last_Name__c = 'TestLastName',
            Email__c = 'test@example.com',
            Gender__c = 'Male',
            Phone__c = '1234567890',
            OTP__c = '1234',
            IsVerify__c = false
        );
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/NameEmail/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '","gender":"Female","email":"updated@example.com","firstname":"UpdatedFirstName","lastname":"UpdatedLastName"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        NameEmailApi.completeProfile(testCustomer.Id, 'Female', 'updated@example.com', 'UpdatedFirstName', 'UpdatedLastName');

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Expected success response');
        System.assert(responseBody.contains('Your Profile is Successfully Completed.'), 'Expected "Profile Completed" message');
        Customer__c updatedCustomer = [SELECT Id, Name, Last_Name__c, Email__c, Gender__c, IsVerify__c FROM Customer__c WHERE Id = :testCustomer.Id];
        System.assertEquals('UpdatedFirstName', updatedCustomer.Name, 'First name should be updated');
        System.assertEquals('UpdatedLastName', updatedCustomer.Last_Name__c, 'Last name should be updated');
        System.assertEquals('updated@example.com', updatedCustomer.Email__c, 'Email should be updated');
        System.assertEquals('Female', updatedCustomer.Gender__c, 'Gender should be updated');
        Test.stopTest();
    }

    @isTest
    static void testCompleteProfile_Failure() {
        // Create test data
        String invalidAccountId = 'invalidAccountId';

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/NameEmail/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + invalidAccountId + '","gender":"Female","email":"updated@example.com","firstname":"UpdatedFirstName","lastname":"UpdatedLastName"}');


        Test.startTest();

        NameEmailApi.completeProfile(invalidAccountId, 'Female', 'updated@example.com', 'UpdatedFirstName', 'UpdatedLastName');

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
   
        Test.stopTest();
    }
}