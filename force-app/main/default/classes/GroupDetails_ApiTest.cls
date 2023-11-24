@isTest
public class GroupDetails_ApiTest {

    @isTest
    static void testGetGroupDetail() {
        // Create test data
        Customer__c user = new Customer__c(Name = 'Test User', Last_Name__c = 'TestLast');
        insert user;

        Group__c testGroup = new Group__c( Name = 'Test Group', Customer__c = user.Id, Date__c = Date.newInstance(2023, 4, 15),Description__c = 'Test Description');
        insert testGroup;

        Group_Member__c member1 = new Group_Member__c(
            Name = 'John Doe',
            LastName__c = 'Doe',
            IsJoined__c = true,
            Attend__c = true,
            IsTentative__c = false,
            MemberId__c = user.Id,
            Group__c = testGroup.Id,
            Role__c = 'Admin'
        );
        insert member1;

        Group_Member__c member2 = new Group_Member__c(
            Name = 'Jane Smith',
            LastName__c = 'Smith',
            IsJoined__c = true,
            Attend__c = false,
            IsTentative__c = true,
            MemberId__c = user.Id,
            Group__c = testGroup.Id,
            Role__c = 'Member'
        );
        insert member2;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GroupDetailsApi';
        request.httpMethod = 'POST';

        // Define the parameters for the request
        String groupId = testGroup.Id;

        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('GroupId', groupId);

        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        // Set the mock class for the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();

        // Call the API method
        GroupDetails_Api.getGroupDetail(groupId);

        Test.stopTest();
/*
        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        System.assertEquals('Test Description', result.get('Description'));
        System.assertEquals('2023-04-15', result.get('GroupDate'));
        System.assertEquals('Test Group', result.get('GroupName'));
        System.assertEquals(5, (Integer)result.get('TotalMembers'));
        System.assertEquals(1, (Integer)result.get('TotalAdmin'));
        System.assertEquals(1, (Integer)result.get('TotalJoined'));
        System.assertEquals(1, (Integer)result.get('TotalTenative'));
        System.assertEquals(0, (Integer)result.get('TotalDeclined'));
*/
    
        // Clean up test data
        delete member1;
        delete member2;
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

        request.requestURI = '/services/apexrest/GroupDetailsApi';
        request.httpMethod = 'POST';

        // Missing GroupId in request body
        Map<String, Object> requestBody = new Map<String, Object>();
        // Comment out or remove the next line to simulate missing GroupId
        // requestBody.put('GroupId', 'testGroupId');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        // Set the mock class for the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();

        // Call the API method
        GroupDetails_Api.getGroupDetail(null);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Failed', result.get('Status'));
    }
    
    // Mock class that simulates a successful HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            Map<String, Object> responseBody = new Map<String, Object>();
            responseBody.put('Status', 'Success');
            res.setBody(JSON.serialize(responseBody));
            return res;
        }
    }
}