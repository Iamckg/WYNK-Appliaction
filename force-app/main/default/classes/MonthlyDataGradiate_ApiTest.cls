@isTest
public class MonthlyDataGradiate_ApiTest {

    @isTest
    static void testGetCalendarDetails() {
        // Create test data
        Customer__c user = new Customer__c(Name = 'Test User');
        insert user;
        Label__c label = new Label__c(Name = 'Test Label');
        insert label;

        // Create two friends without specifying the Id
        Friend__c friend1 = new Friend__c(
            FirstName__c = 'John',
            Last_Name__c = 'Doe',
            Phone__c = '123-456-7890',
            Label__c = label.Id,
            Customer__c = user.Id
        );
        insert friend1;

        Friend__c friend2 = new Friend__c(
            FirstName__c = 'Jane',
            Last_Name__c = 'Smith',
            Phone__c = '987-654-3210',
            Label__c = label.Id,
            Customer__c = user.Id
        );
        insert friend2;

        Calendar__c calendar1 = new Calendar__c(
            Start_Date__c = Date.newInstance(2023, 4, 1),
            Moving_Date__c = Date.newInstance(2023, 4, 5),
            Customer__c = friend1.Name
        );
        insert calendar1;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/MonthlyDataGradiate';
        request.httpMethod = 'POST';

        List<String> stringDates = new List<String> { '2023-04-03' };
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('UserId', user.Id);
        requestBody.put('stringDates', stringDates);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        MonthlyDataGradiate_Api.getHomeList(user.Id, stringDates);

        Test.stopTest();

       

        // Clean up test data
        delete calendar1;
        delete friend1;
        delete friend2;
        delete user;
    }

    @isTest
    static void testNoCalendarDetailsFound() {
        // Create test data
        Customer__c user = new Customer__c(Name = 'Test User');
        insert user;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/MonthlyDataGradiate';
        request.httpMethod = 'POST';

        List<String> stringDates = new List<String> { '2023-04-03' };
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('UserId', user.Id);
        requestBody.put('stringDates', stringDates);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        MonthlyDataGradiate_Api.getHomeList(user.Id, stringDates);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));

        // Clean up test data
        delete user;
    }

    @isTest
    static void testApiErrorHandling() {
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/MonthlyDataGradiate';
        request.httpMethod = 'POST';

        // Missing UserId in request body
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('stringDates', new List<String> { '2023-04-03' });
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        MonthlyDataGradiate_Api.getHomeList(null, new List<String> { '2023-04-03' });

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
    }
}