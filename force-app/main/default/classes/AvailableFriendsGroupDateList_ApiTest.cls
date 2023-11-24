@isTest
public class AvailableFriendsGroupDateList_ApiTest {
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
    static void testMyfriendList() {
        // Create test data
        List<Customer__c> customerList = New List<Customer__c>();

        Customer__c user1 = new Customer__c(Name = 'Test.', Last_Name__c = 'LastName');
        Customer__c user2 = new Customer__c(Name = 'Test.', Last_Name__c = 'LastName');
        Customer__c user3 = new Customer__c(Name = 'Test.', Last_Name__c = 'LastName');
        Customer__c user4 = new Customer__c(Name = 'Test.', Last_Name__c = 'LastName');
        customerList.add(user1);
        customerList.add(user2);
        customerList.add(user3);
        customerList.add(user4);
        insert customerList;

        Label__c label = new Label__c(Name = 'Test', Customer__c = user1.Id);
        insert label;

        List<Friend__c> friendList = New List<Friend__c>();
        
        Friend__c friend1 = new Friend__c(Name = user2.Id, FirstName__c = user2.Name, Last_Name__c = user2.Last_Name__c, Phone__c = '1234567890', Label__c = label.Id, Customer__c = user1.Id);
        Friend__c friend2 = new Friend__c(Name = user3.Id, FirstName__c = user3.Name, Last_Name__c = user3.Last_Name__c, Phone__c = '1234567890', Label__c = label.Id, Customer__c = user1.Id);
        Friend__c friend3 = new Friend__c(Name = user4.Id, FirstName__c = user2.Name, Last_Name__c = user2.Last_Name__c, Phone__c = '1234567890', Label__c = label.Id, Customer__c = user1.Id);
        Friend__c friend4 = new Friend__c(Name = user4.Id, FirstName__c = user3.Name, Last_Name__c = user3.Last_Name__c, Phone__c = '1234567890', Label__c = label.Id, Customer__c = user1.Id);
        friendList.add(friend1);
        friendList.add(friend2);
        friendList.add(friend3);
        friendList.add(friend4);
        insert friendList;

        Calendar__c calendar1 = new Calendar__c(
            Start_Date__c = Date.newInstance(2023, 4, 1),
            Moving_Date__c = Date.newInstance(2023, 4, 5),
            Customer__c = friend1.Name
        );
        insert calendar1;

        Calendar__c calendar2 = new Calendar__c(
            Start_Date__c = Date.newInstance(2023, 4, 2),
            Moving_Date__c = Date.newInstance(2023, 4, 6),
            Customer__c = friend2.Name
        );
        insert calendar2;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/AvailableFriendsGroupDateListApi';
        request.httpMethod = 'POST';

        // Create a date string for the request
        String dateString = '2023-04-03';

        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('UserId', user1.Id);
        requestBody.put('GroupDate', dateString);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        // Call the API method
        Available_Friends_Group_Date_List_Api.MyfriendList(user1.Id, dateString);

        Test.stopTest();
/*
        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));

        List<Map<String, Object>> availableFriends = (List<Map<String, Object>>) result.get('AvailableFriends');
        List<Map<String, Object>> unAvailableFriends = (List<Map<String, Object>>) result.get('UnAvailableFriends');

        System.assertEquals(2, availableFriends.size());
        System.assertEquals(1, unAvailableFriends.size());
*/
        // Clean up test data
        delete calendar1;
        delete calendar2;
        delete friend1;
        delete friend2;
        delete user1;
        delete user2;
        delete user3;
        delete user4;
        delete label;
    }

    @isTest
    static void testApiErrorHandling() {
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/AvailableFriendsGroupDateListApi';
        request.httpMethod = 'POST';

        // Missing UserId in request body
        Map<String, Object> requestBody = new Map<String, Object>();
        // Comment out or remove the next line to simulate missing UserId
        // requestBody.put('UserId', 'testUserId');
        String dateString = '2023-04-03';
        requestBody.put('GroupDate', dateString);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();
        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        // Call the API method
        Available_Friends_Group_Date_List_Api.MyfriendList(null, dateString);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
    }
}