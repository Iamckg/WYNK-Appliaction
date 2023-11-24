@isTest
private class LabelListApiTest {
    @isTest
    static void testGetLabelListSuccess() {
        // Create a test customer record
        Customer__c testCustomer = new Customer__c(  Name = 'Test User' );
        insert testCustomer;

        // Create a test label records associated with the customer
        Label__c label1 = new Label__c(Name = 'Label 1', Customer__c = testCustomer.Id);
        Label__c label2 = new Label__c(Name = 'Label 2', Customer__c = testCustomer.Id);
        insert new List<Label__c> {label1, label2};

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/LabelList/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testCustomer.Id + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        LabelList_Api.getLabelList(testCustomer.Id);

        // Perform assertions
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('LabelList'), 'Response should contain LabelList');

        // Query the database to ensure that label records are retrieved correctly
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        List<Object> labelList = (List<Object>) responseMap.get('LabelList');
        System.assertEquals(2, labelList.size(), 'Expected 2 label records in the response');
        System.assertEquals('Label 1', ((Map<String, Object>)labelList[0]).get('Name'), 'Label 1 name should match');
        System.assertEquals('Label 2', ((Map<String, Object>)labelList[1]).get('Name'), 'Label 2 name should match');

        Test.stopTest();
    }

    @isTest
    static void testGetLabelListFailure() {
        // Set up the request with a non-existing UserId
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/LabelList/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":""}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        LabelList_Api.getLabelList('');

        // Perform assertions
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
   
        Test.stopTest();
    }
}