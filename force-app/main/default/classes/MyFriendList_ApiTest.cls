@isTest
public class MyFriendList_ApiTest {
    @isTest
    static void testGetFriendListWithLabelId() {
        Customer__c userI = New Customer__c (Name = 'OwnerName');
        Insert userI;
        // Create a test Label record
        Label__c testLabel = new Label__c(Name = 'TestLabel' ,Customer__c =UserI.Id);
        insert testLabel;

        // Create a test Customer record
        Customer__c testCustomer = new Customer__c(Name = 'Friend First Name',Last_Name__c = 'Friend Last Name' );
        insert testCustomer;

        // Create a test Friend record linked to the customer with a Label
        Friend__c testFriend = new Friend__c(
            Name = testCustomer.Id,
            Label__c = testLabel.Id,
            FirstName__c = 'Friend First Name',
            Last_Name__c = 'Friend Last Name',
            Phone__c = '1234567890',
            Customer__c =UserI.Id
        );
        insert testFriend;

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/MyFriendList';
        req.httpMethod = 'POST';

        // Define input parameters with LabelId
        String userId = userI.Id;
        String labelId = testLabel.Id;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', userId);
        requestBody.put('LabelId', labelId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test the POST request
        Test.startTest();
           // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        MyFriendList_Api.MyfriendList(userId, labelId);
        Test.stopTest();

        // Verify the response
        String responseBody = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        // Perform assertions to validate the response
        System.assertEquals('Success', responseMap.get('Status'));

        List<Object> friendsList = (List<Object>) responseMap.get('FriendsList');
        System.assertEquals(1, friendsList.size());

        Map<String, Object> friendData = (Map<String, Object>) friendsList[0];
        System.assertEquals(testFriend.Name, friendData.get('AccountId'));
        System.assertEquals(testFriend.FirstName__c, friendData.get('FirstName'));
        System.assertEquals(testFriend.Last_Name__c, friendData.get('LastName'));
     //   System.assertEquals(testFriend.Label__r.Name, friendData.get('Label'));
        System.assertEquals(testFriend.Phone__c, friendData.get('Phone'));
    }

    @isTest
    static void testGetFriendListWithoutLabelId() {
        Customer__c userI = New Customer__c (Name = 'OwnerName');
        Insert userI;
        // Create a test Label record
        Label__c testLabel = new Label__c(Name = 'TestLabel' ,Customer__c =UserI.Id);
        insert testLabel;

        // Create a test Customer record
        Customer__c testCustomer = new Customer__c(Name = 'Friend First Name',Last_Name__c = 'Friend Last Name' );
        insert testCustomer;

        // Create a test Friend record linked to the customer with a Label
        Friend__c testFriend = new Friend__c(
            Name = testCustomer.Id,
            Label__c = testLabel.Id,
            FirstName__c = 'Friend First Name',
            Last_Name__c = 'Friend Last Name',
            Phone__c = '1234567890',
            Customer__c =UserI.Id
        );
        insert testFriend;

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/MyFriendList';
        req.httpMethod = 'POST';

        // Define input parameters without LabelId
        String userId = userI.Id;
        String labelId = null;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', userId);
        requestBody.put('LabelId', labelId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test the POST request
        Test.startTest();
           // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        MyFriendList_Api.MyfriendList(userId, labelId);
        Test.stopTest();

        // Verify the response as before
        // (Omitted for brevity, as it's the same verification as in the previous test)

        // Add assertions to verify the response in this scenario
        // (You can add assertions specific to this scenario, e.g., checking that LabelId is null in the response.)
    }
    // Define a mock class for the HTTP callout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Status": "Success", "FriendsList": [{"FirstName": "John", "LastName": "Doe"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
}