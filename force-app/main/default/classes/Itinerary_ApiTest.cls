@isTest
public class Itinerary_ApiTest {
    @isTest
    static void testCreateCalendarSuccess() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;

        // Define input parameters
        String userId = testUser.Id;
        String startDate = '2023-01-01';
        String movingDate = '2023-01-10';
        String location = 'Test Location';
        Boolean isTentative = false;
        String type = 'Save';

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/Itinerary';
        req.httpMethod = 'POST';
        
        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', userId);
        requestBody.put('StartDate', startDate);
        requestBody.put('MovingDate', movingDate);
        requestBody.put('Location', location);
        requestBody.put('IsTentative', String.valueOf(isTentative));
        requestBody.put('Type', type);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);
        
        // Test a successful calendar creation request
        Test.startTest();
        Itinerary_Api.createCalendar(userId, startDate, movingDate,location,isTentative, type);
        Test.stopTest();

        // Query the Calendar record to check if it was inserted
        List<Calendar__c> calendars = [SELECT Id FROM Calendar__c WHERE Customer__c = :userId LIMIT 1];
        System.assertEquals(1, calendars.size(), 'More than one calendar record created.');
    }

    @isTest
    static void testCreateCalendarFailure() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;
        
        // Define input parameters
        String userId = testUser.Id;
        String startDate = '2023-01-01';
        String movingDate = '2023-01-10';
        String location = 'Test Location';
        Boolean isTentative = false;
        String type = 'InvalidType';

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/Itinerary';
        req.httpMethod = 'POST';
        
        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', userId);
        requestBody.put('StartDate', startDate);
        requestBody.put('MovingDate', movingDate);
        requestBody.put('Location', location);
        requestBody.put('IsTentative', String.valueOf(isTentative));
        requestBody.put('Type', type);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);
        
        // Test a failed calendar creation request
        Test.startTest();
        Itinerary_Api.createCalendar(userId, startDate, movingDate,location,isTentative, type);
        Test.stopTest();

        // Query the Calendar record to check if it was not inserted
        List<Calendar__c> calendars = [SELECT Id FROM Calendar__c WHERE Customer__c = :userId LIMIT 1];
        System.assertEquals(0, calendars.size(), 'Calendar record should not be created with an invalid type.');
    }
}