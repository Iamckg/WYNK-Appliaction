@isTest
public class CalendarEdit_ApiTest {
    @isTest
    static void testUpdateCalendarSuccess() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;
        
        // Create a test Calendar record
        Calendar__c testCalendar = new Calendar__c();
        testCalendar.Start_Date__c = Date.valueOf('2023-02-01');
        testCalendar.Moving_Date__c = Date.valueOf('2023-02-10');
        testCalendar.Location__c = 'Test Location';
        testCalendar.isTentative__c = false;
        testCalendar.Type__c = 'Save';
        testCalendar.Customer__c =testUser.Id;
        insert testCalendar;

        // Define input parameters
        String calendarId = testCalendar.Id;
        String startDate = '2023-02-01';
        String movingDate = '2023-02-10';
        String location = 'Updated Location';
        Boolean isTentative = true;
        String type = 'Save';

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/CalendarEdit';
        req.httpMethod = 'POST';

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('CalendarId', calendarId);
        requestBody.put('StartDate', startDate);
        requestBody.put('MovingDate', movingDate);
        requestBody.put('Location', location);
        requestBody.put('IsTentative', String.valueOf(isTentative));
        requestBody.put('Type', type);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test a successful calendar update request
        Test.startTest();
        CalendarEdit_Api.createCalendar(calendarId, startDate, movingDate, location, isTentative, type);
        Test.stopTest();

        // Query the Calendar record to check if it was updated
        Calendar__c updatedCalendar = [SELECT Start_Date__c, Type__c, Moving_Date__c, Location__c, isTentative__c FROM Calendar__c WHERE Id = :calendarId LIMIT 1];

        // Add assertions to check the updated values
        System.assertEquals(Date.valueOf(startDate), updatedCalendar.Start_Date__c);
        System.assertEquals(type, updatedCalendar.Type__c);
        System.assertEquals(Date.valueOf(movingDate), updatedCalendar.Moving_Date__c);
        System.assertEquals(location, updatedCalendar.Location__c);
        System.assertEquals(isTentative, updatedCalendar.isTentative__c);
    }

    @isTest
    static void testUpdateCalendarFailure() {
        // Define input parameters with an invalid CalendarId
        String calendarId = 'invalidId';
        String startDate = '2023-02-01';
        String movingDate = '2023-02-10';
        String location = 'Updated Location';
        Boolean isTentative = true;
        String type = 'Update';

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/CalendarEdit';
        req.httpMethod = 'POST';

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('CalendarId', calendarId);
        requestBody.put('StartDate', startDate);
        requestBody.put('MovingDate', movingDate);
        requestBody.put('Location', location);
        requestBody.put('IsTentative', String.valueOf(isTentative));
        requestBody.put('Type', type);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test a failed calendar update request
        Test.startTest();
        CalendarEdit_Api.createCalendar(calendarId, startDate, movingDate, location, isTentative, type);
        Test.stopTest();
    }
    @isTest
    static void testelse() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;
        
        // Create a test Calendar record
        Calendar__c testCalendar = new Calendar__c();
        testCalendar.Start_Date__c = Date.valueOf('2023-02-01');
        testCalendar.Moving_Date__c = Date.valueOf('2023-02-10');
        testCalendar.Location__c = 'Test Location';
        testCalendar.isTentative__c = false;
        testCalendar.Type__c = 'Save';
        testCalendar.Customer__c =testUser.Id;
        insert testCalendar;

        // Define input parameters
        String calendarId = testCalendar.Id;
        String startDate = '2023-02-01';
        String movingDate = '2023-02-10';
        String location = 'Updated Location';
        Boolean isTentative = true;
        String type = 'Save';

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/CalendarEdit';
        req.httpMethod = 'POST';

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('CalendarId', 'calendarId');
        requestBody.put('StartDate', startDate);
        requestBody.put('MovingDate', movingDate);
        requestBody.put('Location', location);
        requestBody.put('IsTentative', String.valueOf(isTentative));
        requestBody.put('Type', type);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test a successful calendar update request
        Test.startTest();
        CalendarEdit_Api.createCalendar('calendarId', startDate, movingDate, location, isTentative, type);
        Test.stopTest();

    }
}