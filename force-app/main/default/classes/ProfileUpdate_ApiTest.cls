@isTest
private class ProfileUpdate_ApiTest {
    @isTest
    static void testCompleteProfile_Success() {
        // Create a test customer record
        Customer__c testCustomer = new Customer__c( Name = 'TestUser', Last_Name__c = 'TestLastName',  Email__c = 'test@example.com',
        Phone__c = '1234567890',OTP__c = '1234', Date_of_Birth__c = Date.newInstance(1990, 10, 10), IsProfile__c = true, IsVerify__c = true,
        Country__c = 'USA',  State__c = 'CA', City__c = 'San Francisco',  Password__c = 'testpassword' );
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/profileUpdate/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + 
                      '","firstname":"UpdatedFirstName","lastname":"UpdatedLastName","gender":"Female","country":"Canada","state":"ON","city":"Toronto","dob":"1980-05-05","ImageUrl":"https://b2.com/mohit99.jpeg"}');

        // Start the test
        Test.startTest();
        ProfileUpdate_Api.completeProfile(testCustomer.Id, 'UpdatedFirstName', 'UpdatedLastName', 'Female', 'Canada', 'ON', 'Toronto', '1980-05-05','https://b2.com/mohit99.jpeg');

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('Your Profile is Successfully Completed.'), 'Message should indicate successful profile update');

        // Query the database to ensure that the record was updated
        Customer__c updatedCustomer = [SELECT Id, Name, Last_Name__c, Email__c, Gender__c, Phone__c, Date_of_Birth__c, IsProfile__c, IsVerify__c, Country__c, State__c, City__c, Password__c
            FROM Customer__c WHERE Id = :testCustomer.Id];
        System.assertNotEquals(null, updatedCustomer, 'User record should exist');
        System.assertEquals('UpdatedFirstName', updatedCustomer.Name, 'Name should match');
        System.assertEquals('UpdatedLastName', updatedCustomer.Last_Name__c, 'Last name should match');
        System.assertEquals('Female', updatedCustomer.Gender__c, 'Gender should match');
        System.assertEquals('Canada', updatedCustomer.Country__c, 'Country should match');
        System.assertEquals('ON', updatedCustomer.State__c, 'State should match');
        System.assertEquals('Toronto', updatedCustomer.City__c, 'City should match');
        System.assertEquals(Date.newInstance(1980, 5, 5), updatedCustomer.Date_of_Birth__c, 'Date of Birth should match');

        Test.stopTest();
    }

    @isTest
    static void testCompleteProfile_CustomerNotFound() {
        // Set up the request with a non-existing AccountId
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/profileUpdate/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"invalidAccountId","firstname":"UpdatedFirstName","lastname":"UpdatedLastName","gender":"Female","country":"Canada","state":"ON","city":"Toronto","dob":"1980-05-05","ImageUrl":"https://b2.com/mohit99.jpeg"}');

        // Start the test
        Test.startTest();
        // Invoke the API method
        ProfileUpdate_Api.completeProfile('invalidAccountId', 'UpdatedFirstName', 'UpdatedLastName', 'Female', 'Canada', 'ON', 'Toronto', '1980-05-05','https://b2.com/mohit99.jpeg');
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
        String responseBody = res.responseBody.toString();
        Test.stopTest();
    }
}