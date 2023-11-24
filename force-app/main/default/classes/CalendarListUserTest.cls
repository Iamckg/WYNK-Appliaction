@isTest
public class CalendarListUserTest {
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
    static void testGetCalendarList() {
        // Create a test Label record
        Label__c testLabel = new Label__c(Name = 'Test Label');
        insert testLabel;

        // Create a test Customer record
        Customer__c testCustomer = new Customer__c(Name = 'Test Customer',  Last_Name__c = 'Lastname', Label__c = testLabel.Id  );
        insert testCustomer;

        // Create a test Calendar record
        Calendar__c testCalendar = new Calendar__c(
            Start_Date__c = Date.valueOf('2023-01-01'),
            SaveDate__c = Date.valueOf('2023-01-10'),
            Title__c = 'Test Title',
            Moving_Date__c= Date.valueOf('2023-01-11'),
            Customer__c = testCustomer.Id
        );
        insert testCalendar;

        // Create a test Friend record linking the customer to the calendar
        Friend__c testFriend = new Friend__c(
            Name = testCustomer.Id,
            Customer__c = testCustomer.Id
        );
        insert testFriend;

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/CalendarUsersList';
        req.httpMethod = 'GET';

        // Test the GET request
        Test.startTest();
            // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        CalendarListUser.getCalendarList();
        Test.stopTest();

        // Verify the response
        String responseBody = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        // Perform assertions to validate the response
        System.assertEquals('Success', responseMap.get('Status'));

        List<Object> calendarList = (List<Object>) responseMap.get('CalendarList');
        System.assertEquals(1, calendarList.size());

        Map<String, Object> calendarData = (Map<String, Object>) calendarList[0];
        System.assertEquals(testCalendar.Id, calendarData.get('calendarId'));
        System.assertEquals(Date.valueOf('2023-01-01'), Date.valueOf(calendarData.get('StartDate').toString()));
        System.assertEquals(Date.valueOf('2023-01-11'), Date.valueOf(calendarData.get('MovingDate').toString()));
        System.assertEquals('Test Title', calendarData.get('Title'));

        List<Object> friendsList = (List<Object>) calendarData.get('Friends');
        System.assertEquals(1, friendsList.size());

        Map<String, Object> friendData = (Map<String, Object>) friendsList[0];
        System.assertEquals(testCustomer.Id, friendData.get('AccountId'));
        System.assertEquals('Test Customer', friendData.get('FirstName'));
    }
}