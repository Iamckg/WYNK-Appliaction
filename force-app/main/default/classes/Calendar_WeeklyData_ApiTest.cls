@isTest
public class Calendar_WeeklyData_ApiTest {

    @isTest
    static void testCalendarWeeklyData() {
        // Create a test User record
        Customer__c testUser = new Customer__c(Name = 'firstCustomer', Last_Name__c = 'LastnameCustomer');
        insert testUser;

        // Create a test Label record
        Label__c testLabel = new Label__c(Name = 'TestLabel', Customer__c = testUser.Id);
        insert testLabel;

        // Create a test Customer record
        Customer__c testCustomer = new Customer__c(Name = 'Friend First Name', Last_Name__c = 'Friend Last Name');
        insert testCustomer;

        // Create a test Friend record
        Friend__c testFriend = new Friend__c(Name = testCustomer.Id, Label__c = testLabel.Id, FirstName__c = testCustomer.Name, Last_Name__c = testCustomer.Last_Name__c, Customer__c = testUser.Id);
        insert testFriend;

       // Create a test Calendar record for the friend
Calendar__c testCalendar = new Calendar__c(
    Start_Date__c = Date.valueOf('2023-11-22'),
    isTentative__c = true,
    Type__c = 'Save',
    SaveDate__c = Date.valueOf('2023-01-10'),
    Title__c = 'Test Title',
    Customer__c = testCustomer.Id,
    Moving_Date__c = Date.valueOf('2023-01-05')  // Set Moving_Date__c to a date within the same week
);
insert testCalendar;

        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Set up the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/CalendarWeeklyData/';
        request.httpMethod = 'POST';

        // Define the parameters for the request
        String userId = testUser.Id;
        List<String> dates = new List<String>{String.valueOf(Date.today())};
        String labelId = testLabel.Id;

        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('UserId', userId);
        requestBody.put('Dates', dates);
        requestBody.put('LabelId', labelId);

        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        Calendar_WeeklyData_Api.getHomeList(userId, dates, labelId);

        Test.stopTest();
/*
        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        List<Map<String, Object>> homeList = (List<Map<String, Object>>) result.get('HomeList');
*/
        // Add assertions for the response data
        // ...

        // Clean up test data
        delete testCalendar;
        delete testFriend;
        delete testLabel;
        delete testUser;
    }
@isTest
    static void test1() {
        // Create a test User record
        Customer__c testUser = new Customer__c(Name = 'firstCustomer', Last_Name__c = 'LastnameCustomer');
        insert testUser;

        // Create a test Label record
        Label__c testLabel = new Label__c(Name = 'TestLabel', Customer__c = testUser.Id);
        insert testLabel;

        // Create a test Customer record
        Customer__c testCustomer = new Customer__c(Name = 'Friend First Name', Last_Name__c = 'Friend Last Name');
        insert testCustomer;

        // Create a test Friend record
        Friend__c testFriend = new Friend__c(Name = testCustomer.Id, Label__c = testLabel.Id, FirstName__c = testCustomer.Name, Last_Name__c = testCustomer.Last_Name__c, Customer__c = testUser.Id);
        insert testFriend;

        // Create a test Calendar record for the friend
        Calendar__c testCalendar = new Calendar__c(
            Start_Date__c = Date.valueOf('2023-01-01'),
            isTentative__c = true,
            Type__c = 'Save',
            SaveDate__c = Date.valueOf('2023-01-10'),
            Title__c = 'Test Title',
            Customer__c = testCustomer.Id,
            Moving_Date__c = Date.valueOf('2023-01-15')
        );
        insert testCalendar;

        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Set up the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/CalendarWeeklyData/';
        request.httpMethod = 'POST';

        // Define the parameters for the request
        String userId = testUser.Id;
        List<String> dates = new List<String>{String.valueOf(Date.today())};
        String labelId = testLabel.Id;

        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('UserId', userId);
        requestBody.put('Dates', dates);
      

        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        Calendar_WeeklyData_Api.getHomeList(userId, dates, 'labelId');

        Test.stopTest();

        delete testCalendar;
        delete testFriend;
        delete testLabel;
        delete testUser;
    }

    // Define a mock class for the HTTP callout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Status": "Success", "HomeList": [{"FirstName": "John", "LastName": "Doe"}], "Labels": ["TestLabel"]}');
            res.setStatusCode(200);
            return res;
        }
    }
}