@isTest
private class LabelEditApiTest {
    @isTest
    static void testEditLabelSuccess() {
        // Create a test label record
        Label__c testLabel = new Label__c(Name = 'Test Label');
        insert testLabel;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/LabelDelete/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testLabel.Id + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        LabelEdit_Api.editLabel(testLabel.Id);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('Label has been Deleted successfully'), 'Response message should indicate success');

        // Query the database to ensure that the label record is deleted
        List<Label__c> deletedLabels = [SELECT Id FROM Label__c WHERE Id = :testLabel.Id];
        System.assertEquals(0, deletedLabels.size(), 'Label record should be deleted');

        Test.stopTest();
    }

    @isTest
    static void testEditLabelFailure() {
        // Set up the request with a non-existing AccountId
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/LabelDelete/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"invalidLabelId"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        LabelEdit_Api.editLabel('invalidLabelId');

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status should be Failed');
        System.assert(responseBody.contains('message'), 'Response should contain the message field');

        Test.stopTest();
    }
}