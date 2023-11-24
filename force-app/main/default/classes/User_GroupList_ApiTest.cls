@isTest
public class User_GroupList_ApiTest {

    // MockHttpResponseGenerator class to simulate HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"Status": "Success", "GroupList": [{"IsJoined": true, "IsAttend": false, "IsDeclined": false, "GroupName": "Test Group", "Description": "Test Description", "TotalMembers": 1, "GroupDate": "2023-04-15"}]}');
            return res;
        }
    }

    @isTest
    static void testGetGroupList() {
        // Create test data
        Customer__c user = new Customer__c(Name = 'Test User', Last_Name__c = 'TestLast');
        insert user;

        // Create a test group
        Group__c testGroup = new Group__c(
            Name = 'Test Group',
            Customer__c = user.Id,
            Date__c = Date.newInstance(2023, 4, 15),
            Description__c = 'Test Description'
        );
        insert testGroup;

        // Add the user to the test group
        Group_Member__c groupMember = new Group_Member__c(
            MemberId__c = user.Id,
            Group__c = testGroup.Id,
            IsJoined__c = true,
            Attend__c = false,
            Declined__c = false
        );
        insert groupMember;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/UserGroupList';
        request.httpMethod = 'POST';

        // Define the parameters for the request
        String userId = user.Id;

        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('UserId', userId);

        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        // Set the mock for the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();

        // Call the API method
        User_GroupList_Api.getGroupList(userId);

        Test.stopTest();
/*
        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        List<Map<String, Object>> groupList = (List<Map<String, Object>>) result.get('GroupList');

        System.assertEquals(1, groupList.size());
        Map<String, Object> groupData = groupList[0];

        System.assertEquals(true, groupData.get('IsJoined'));
        System.assertEquals(false, groupData.get('IsAttend'));
        System.assertEquals(false, groupData.get('IsDeclined'));
        System.assertEquals('Test Group', groupData.get('GroupName'));
        System.assertEquals('Test Description', groupData.get('Description'));
        System.assertEquals(1, groupData.get('TotalMembers'));
        System.assertEquals('2023-04-15', groupData.get('GroupDate'));
*/
        // Clean up test data
        delete groupMember;
        delete testGroup;
        delete user;
    }

    @isTest
    static void testApiErrorHandling() {
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/UserGroupList';
        request.httpMethod = 'POST';

        // Missing UserId in request body
        Map<String, Object> requestBody = new Map<String, Object>();
        // Comment out or remove the next line to simulate missing UserId
        // requestBody.put('UserId', 'testUserId');

        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        User_GroupList_Api.getGroupList(null);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
    }
}