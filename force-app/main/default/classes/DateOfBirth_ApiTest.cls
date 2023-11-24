@isTest
private class DateOfBirth_ApiTest {

    @isTest
    static void testCompleteProfile_Success() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c();
        testCustomer.Name = 'TestUser';
        testCustomer.Last_Name__c = 'TestLastName';
        testCustomer.Email__c = 'test@example.com';
        testCustomer.Password__c = '123456';
        testCustomer.Country__c = 'USA';
        testCustomer.IsVerify__c = false;
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        Date dateOfBirth = Date.newInstance(2023, 10, 10);
        String formattedDateOfBirth = '2023-10-10';
        req.requestURI = '/services/apexrest/dob/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '","dob":"' + formattedDateOfBirth + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        DateOfBirth_Api.completeProfile(testCustomer.Id, formattedDateOfBirth);

        // Perform assertions for success scenario
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
      //  System.assert(responseBody.contains('Success'), 'Status');
      //  System.assert(responseBody.contains('Your Profile is Successfully Completed.'), 'message');

        // Query the database to ensure that the Date_of_Birth__c field is updated
        Customer__c updatedCustomer = [SELECT Id, Date_of_Birth__c, IsVerify__c, Country__c, Email__c, Last_Name__c, Name FROM Customer__c WHERE Id = :testCustomer.Id];
        System.assertEquals(dateOfBirth, updatedCustomer.Date_of_Birth__c, 'Date of Birth should be updated');
        System.assertEquals(false, updatedCustomer.IsVerify__c, 'IsVerify should be false');
        System.assertEquals('USA', updatedCustomer.Country__c, 'Country should be updated');
        System.assertEquals('test@example.com', updatedCustomer.Email__c, 'Email should be updated');
      //  System.assertEquals('123456', updatedCustomer.Password__c, 'Password should remain unchanged');
        System.assertEquals('TestLastName', updatedCustomer.Last_Name__c, 'Last Name should remain unchanged');
        System.assertEquals('TestUser', updatedCustomer.Name, 'Name should remain unchanged');

        // End the test
        Test.stopTest();
    }

    @isTest
    static void testCompleteProfile_Failure() {
        // Set up the request with an invalid AccountId
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/dob/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"invalidAccountId","dob":"1990-10-10"}');

        // Start the test
        Test.startTest();

        // Invoke the API method with an invalid AccountId
        DateOfBirth_Api.completeProfile('invalidAccountId', '1990-10-10');

        // Perform assertions for failure scenario (invalid AccountId)
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status');
        System.assert(responseBody.contains('message'), 'message');

        // End the test
        Test.stopTest();
    }
}