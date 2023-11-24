@isTest
public class Save_Date_ApiTest {
    @isTest
    static void testSaveDateApi() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;
        // Define the parameters for the API request
        String userId = testUser.Id;
        String saveDate = '2023-10-20';
        String title = 'Test Event';
        String type = 'Save';

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/saveDate';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', userId);
        requestBody.put('SaveDate', saveDate);
        requestBody.put('title', title);
        requestBody.put('Type', type);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Call the REST API
        Save_Date_Api.UpdateCalendar(userId, saveDate, title, type);

        // Check the response
        String jsonResponse = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);

        System.assertEquals('Success', responseMap.get('Status'));

    }
    @isTest
    static void testCatch() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;
        // Define the parameters for the API request
        String userId = testUser.Id;
        String saveDate = 'test';
        String title = 'Test Event';
        String type = 'Save';

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/saveDate';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', userId);
        requestBody.put('SaveDate', saveDate);
        requestBody.put('title', title);
        requestBody.put('Type', type);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);
        Save_Date_Api.UpdateCalendar(userId, saveDate, title, type);
        String jsonResponse = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
    }
}