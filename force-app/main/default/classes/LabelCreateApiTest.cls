@isTest
private class LabelCreateApiTest {
    @isTest
    static void testCreateLabelSuccess() {
        // Create a test customer record
        Customer__c testCustomer = new Customer__c(
            Name = 'Test User'

        );
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/LabelCreate/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"label":"Test Label","UserId":"' + testCustomer.Id + '","Colour":"123455"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        LabelCreate_Api.createLabel('Test Label', testCustomer.Id,'123455');

        // Perform assertions

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('Label has been created successfully'), 'Message should indicate successful label creation');

        // Query the database to ensure that the label record is created
        List<Label__c> labelRecords = [SELECT Id, Name, Customer__c FROM Label__c WHERE Name = 'Test Label' AND Customer__c = :testCustomer.Id];
        System.assertEquals(1, labelRecords.size(), 'One label record should exist');
        System.assertEquals('Test Label', labelRecords[0].Name, 'Label name should match');
        System.assertEquals(testCustomer.Id, labelRecords[0].Customer__c, 'Customer should match');

        Test.stopTest();
    }
    
    
    @isTest
    static void testCreateCatchBlock() {
        // Create a test customer record
        Customer__c testCustomer = new Customer__c(
            Name = 'Test User'

        );

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/LabelCreate/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"label":"","UserId":"","Colour":""}');

        // Start the test
        Test.startTest();
     
        // Invoke the API method
        LabelCreate_Api.createLabel('','','');

        // Perform assertions

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
     

        Test.stopTest();
    }

    
    
    @isTest
    static void testCreateLabelFailure() {
        // Create a test customer record
        Customer__c testCustomer = new Customer__c(
            Name = 'Test User'
        );
        insert testCustomer;

        // Create a label record with the same name
        Label__c existingLabel = new Label__c(Name = 'Test Label', Customer__c = testCustomer.Id);
        insert existingLabel;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/LabelCreate/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"label":"Test Label","UserId":"' + testCustomer.Id + '","Colour":"123455"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        LabelCreate_Api.createLabel('Test Label', testCustomer.Id,'1234567');

        // Perform assertions
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status should be Failed');
        System.assert(responseBody.contains('Label Name already exists !!'), 'Message should indicate label name already exists');

        Test.stopTest();
    }
}