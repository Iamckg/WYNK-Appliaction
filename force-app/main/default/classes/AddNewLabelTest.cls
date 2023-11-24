@isTest
private class AddNewLabelTest {
    @isTest
    static void testUpdateLabelSuccess() {
        // Create a test user record
        Customer__c testUser = new Customer__c(Name = 'Test User');
        insert testUser;

        // Create a test friend record related to the test user
        Friend__c testFriend = new Friend__c(Name = 'Test Friend', Customer__c = testUser.Id);
        insert testFriend;

        // Create a test label record
        Label__c testLabel = new Label__c(Name = 'Test Label');
        insert testLabel;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/AddNewLabel/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"' + testUser.Id + '","FriendUserId":"' + testFriend.Name + '","labelId":"' + testLabel.Id + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        AddNewLabel.UpdateLabel(testUser.Id, testFriend.Name, testLabel.Id);

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');
        System.assert(responseBody.contains('Your Label is Successfully Added'), 'Response message should indicate success');

        // Query the database to ensure that the friend record is updated with the label
        Friend__c updatedFriend = [SELECT Label__c FROM Friend__c WHERE Id = :testFriend.Id];
        System.assertEquals(testLabel.Id, updatedFriend.Label__c, 'Friend record should be updated with the label');

        Test.stopTest();
    }

    @isTest
    static void testUpdateLabelFailure() {
        // Set up the request with non-existing UserId and FriendUserId
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/AddNewLabel/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"UserId":"invalidUserId","FriendUserId":"invalidFriendUserId","labelId":"invalidLabelId"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        AddNewLabel.UpdateLabel('invalidUserId', 'invalidFriendUserId', 'invalidLabelId');

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status should be Failed');
        System.assert(responseBody.contains('message'), 'Response should contain the message field');

        Test.stopTest();
    }
}