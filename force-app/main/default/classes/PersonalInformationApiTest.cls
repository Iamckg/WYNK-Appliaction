@isTest
private class PersonalInformationApiTest {

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
        Date_of_Birth__c = Date.newInstance(1990, 10, 10),
        IsProfile__c = true,
        IsVerify__c = true,
        Country__c = 'USA',
        State__c = 'CA',
        City__c = 'San Francisco',
        Password__c = 'testpassword'
    );
    insert testCustomer;

 
    // Set up the request
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    RestContext.request = req;
    RestContext.response = res;

    // Set the request properties
    req.requestURI = '/services/apexrest/PersonalInfo/';
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '"}');

    // Start the test
    Test.startTest();

    // Invoke the API method
    PersonalInformationApi.completeProfile(testCustomer.Id);
    
    // System.assertEquals(200, res.statusCode, 'Expected HTTP 200 status code');
    System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
    
    String responsBody = res.responseBody.toString();
    Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responsBody);
    
    System.assertEquals('Success', responseMap.get('Status'), 'Status should be Success');
    if (responseMap.containsKey('message')) {
        System.assertEquals('Your Profile is Successfully Completed.', responseMap.get('message'), 'Message should indicate successful profile completion');
    } else {
        System.assert(false, 'The "message" field is missing in the response');
    }
    List<Object> profileInfo = (List<Object>) responseMap.get('ProfileInfo');
    System.assert(!profileInfo.isEmpty(), 'Response should contain ProfileInfo');
    System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
    String responseBody = res.responseBody.toString();
    System.assert(responseBody.contains('Success'), 'Status');
    System.assert(responseBody.contains('Your Profile is Successfully Completed.'), 'message');
    System.assert(responseBody.contains('ProfileInfo'), 'Response should contain ProfileInfo');

    // Query the database to ensure that the response contains the correct user data
    Customer__c retrievedCustomer = [SELECT Id, Name, Last_Name__c, Email__c, Gender__c, Phone__c, Date_of_Birth__c, IsProfile__c, IsVerify__c, Country__c, State__c, City__c, Password__c
        FROM Customer__c WHERE Id = :testCustomer.Id];

    Test.stopTest();
}

    @isTest
    static void testCompleteProfile_NoImage() {
        // Create test data without associating an image
        Customer__c testCustomer = new Customer__c(
            Name = 'TestUser',
            Last_Name__c = 'TestLastName',
            Email__c = 'test@example.com',
            Gender__c = 'Male',
            Phone__c = '1234567890',
            OTP__c = '1234',
            Date_of_Birth__c = Date.newInstance(1990, 10, 10),
            IsProfile__c = true,
            IsVerify__c = true,
            Country__c = 'USA',
            State__c = 'CA',
            City__c = 'San Francisco',
            Password__c = 'testpassword'
        );
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/PersonalInfo/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '"}');

        // Start the test
        Test.startTest();

        PersonalInformationApi.completeProfile(testCustomer.Id);
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
        String responseBody = res.responseBody.toString();
        
        Test.stopTest();
    }

    @isTest
    static void testCompleteProfile_NoCustomer() {
        // Set up the request with a non-existing AccountId
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/PersonalInfo/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"invalidAccountId"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        PersonalInformationApi.completeProfile('invalidAccountId');

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status should be Failed');
        System.assert(responseBody.contains('Customer not found.'), 'Message should indicate customer not found');

        Test.stopTest();
    }
    
    
    
    @isTest
    static void testCompleteProfile_esleblock() {
    // Create test data
    Customer__c testCustomer = new Customer__c(
        Name = 'TestUser',
        Last_Name__c = 'TestLastName',
        Email__c = 'test@example.com',
        Gender__c = 'Male',
        Phone__c = '1234567890',
        OTP__c = '1234',
        Date_of_Birth__c = Date.newInstance(1990, 10, 10),
        IsProfile__c = true,
        IsVerify__c = true,
        Country__c = 'USA',
        State__c = 'CA',
        City__c = 'San Francisco',
        Password__c = 'testpassword'
    );
    insert testCustomer;

    // Set up the request
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    RestContext.request = req;
    RestContext.response = res;

    // Set the request properties
    req.requestURI = '/services/apexrest/PersonalInfo/';
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf('{"AccountId":"' + testCustomer.Id + '"}');

    // Start the test
    Test.startTest();

    // Invoke the API method
    PersonalInformationApi.completeProfile(testCustomer.Id);

    System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

    System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

    String responseBody = res.responseBody.toString();
  

    Test.stopTest();
}

    
    
}