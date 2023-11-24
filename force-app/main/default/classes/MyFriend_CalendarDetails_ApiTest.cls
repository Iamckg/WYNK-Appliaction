@isTest
public class MyFriend_CalendarDetails_ApiTest {
     // Define a mock class for the HTTP callout
    private class MyWebServiceMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": "success", "message": "Mock response"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testGetHomeList() {
        // Create test data
        Customer__c user = new Customer__c(Name = 'Friend User', Last_Name__c = 'Last Name', Country__c = 'Country', State__c = 'State', City__c = 'City');
        insert user;
        Label__c lable=new Label__c (Name='Test',Customer__c= user.Id);
        insert lable;

        Customer__c fruser = new Customer__c(Name = 'User Name',Last_Name__c = 'Last Name', Country__c = 'Country', State__c = 'State', City__c = 'City');
        insert fruser;

        Friend__c friend = new Friend__c(Name = fruser.Id,Label__c=lable.Id, Customer__c = user.Id);
        insert friend;

        List<Calendar__c> calendarList = new List<Calendar__c>();
        for (Integer i = 1; i <= 3; i++) {
        calendarList.add(new Calendar__c(Start_Date__c = Date.newInstance(2023, 10, i), Moving_Date__c=Date.newInstance(2023, 10, i + 1), isTentative__c=true,
                                         Type__c ='Save ' ,SaveDate__c =Date.newInstance(2023, 10, i + 1),
                                      Title__c = 'Title ' + i, Customer__c = friend.Name ));
        }
        insert calendarList;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/MyFriendCalendarDetails';
        request.httpMethod = 'POST';

        // Define the parameters for the request
        String friendUserId = friend.Name;
        String userId = user.Id;

        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('FriendUserId', friendUserId);
        requestBody.put('UserId', userId);

        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        // Call the API method
        MyFriend_CalendarDetails_Api.getHomeList(friendUserId, userId);

        Test.stopTest();
/*
        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));

        List<Map<String, Object>> calendarDetails = (List<Map<String, Object>>) result.get('CalendarDetails');
        System.assertEquals(3, calendarDetails.size());
*/
        // Clean up test data
        delete calendarList;
        delete friend;
        delete user;
        delete fruser;
    }

    @isTest
    static void testApiErrorHandling() {
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/MyFriendCalendarDetails';
        request.httpMethod = 'POST';

        // Missing FriendUserId and UserId in the request body
        Map<String, Object> requestBody = new Map<String, Object>();
        // Comment out or remove the next lines to simulate missing FriendUserId and UserId
        // requestBody.put('FriendUserId', 'testFriendUserId');
        // requestBody.put('UserId', 'testUserId');
        
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        // Call the API method
        MyFriend_CalendarDetails_Api.getHomeList(null, null);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Failed', result.get('Status'));
    }
}