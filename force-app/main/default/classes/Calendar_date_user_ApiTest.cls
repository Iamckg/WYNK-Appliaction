@isTest
public class Calendar_date_user_ApiTest {
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
        Customer__c UserI = new Customer__c(Name = 'firstCustomer',Last_Name__c = 'LastnameCustomer');
        insert UserI;
        // Create a test Label record
        Label__c testLabel = new Label__c(Name = 'TestLabel', Customer__c =UserI.Id);
        insert testLabel;
        Customer__c testCustomer = new Customer__c(Name = 'Friend First Name',Last_Name__c = 'Friend Last Name');
        insert testCustomer;
      
        Friend__c testFriend = new Friend__c( Name = testCustomer.Id,  Label__c = testLabel.Id, FirstName__c = testCustomer.Name ,Last_Name__c = testCustomer.Last_Name__c , Customer__c =UserI.Id);
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

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/CalendardateuserApi';
        req.httpMethod = 'POST';

        // Define input parameters
        String userId = UserI.Id;
        String startDate = '2023-01-05';
        String labelId = testLabel.Id;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', userId);
        requestBody.put('Startdate', startDate);
        requestBody.put('LabelId', labelId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test the POST request
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        Calendar_date_user_Api.getHomeList(userId, startDate, labelId);
        Test.stopTest();

        // Verify the response
        String responseBody = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        // Perform assertions to validate the response
        System.assertEquals('Success', responseMap.get('Status'));

        List<Object> homeList = (List<Object>) responseMap.get('HomeList');
        System.assertEquals(1, homeList.size());

        Map<String, Object> customerData = (Map<String, Object>) homeList[0];
        System.assertEquals('TestLabel', customerData.get('Label'));
        System.assertEquals('Friend Last Name', customerData.get('LastName'));
        System.assertEquals('Friend First Name', customerData.get('FirstName'));

        List<Object> calendarsList = (List<Object>) customerData.get('Calendars');
        System.assertEquals(1, calendarsList.size());

        Map<String, Object> calendarData = (Map<String, Object>) calendarsList[0];
        System.assertEquals('Save', calendarData.get('Type'));
        System.assertEquals(true, calendarData.get('Tentative'));
        System.assertEquals(Date.valueOf('2023-01-15'), Date.valueOf(calendarData.get('MovingDate').toString()));
        System.assertEquals('Test Title', calendarData.get('Title'));

        List<Object> labelsList = (List<Object>) responseMap.get('Labels');
        System.assertEquals(1, labelsList.size());

        Map<String, Object> labelData = (Map<String, Object>) labelsList[0];
        System.assertEquals(1, (Integer)labelData.get('FriendCount'));
        System.assertEquals('TestLabel', labelData.get('Name'));
    }
    @isTest
    static void testCatch() {
        Customer__c UserI = new Customer__c(Name = 'firstCustomer',Last_Name__c = 'LastnameCustomer');
        insert UserI;
        // Create a test Label record
        Label__c testLabel = new Label__c(Name = 'TestLabel', Customer__c =UserI.Id);
        insert testLabel;
        Customer__c testCustomer = new Customer__c(Name = 'Friend First Name',Last_Name__c = 'Friend Last Name');
        insert testCustomer;
      
        Friend__c testFriend = new Friend__c( Name = testCustomer.Id,  Label__c = testLabel.Id, FirstName__c = testCustomer.Name ,Last_Name__c = testCustomer.Last_Name__c , Customer__c =UserI.Id);
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

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/CalendardateuserApi';
        req.httpMethod = 'POST';

        // Define input parameters
        String userId = UserI.Id;
        String startDate = '2023-01-05';
        String labelId = testLabel.Id;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', userId);
        requestBody.put('Startdate', startDate);
        requestBody.put('LabelId', labelId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test the POST request
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyWebServiceMock());
        Calendar_date_user_Api.getHomeList(userId, startDate, labelId);
        Test.stopTest();

        // Verify the response
        String responseBody = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        // Perform assertions to validate the response
        System.assertEquals('Success', responseMap.get('Status'));

        List<Object> homeList = (List<Object>) responseMap.get('HomeList');
        System.assertEquals(1, homeList.size());

        Map<String, Object> customerData = (Map<String, Object>) homeList[0];
        System.assertEquals('TestLabel', customerData.get('Label'));
        System.assertEquals('Friend Last Name', customerData.get('LastName'));
        System.assertEquals('Friend First Name', customerData.get('FirstName'));

        List<Object> calendarsList = (List<Object>) customerData.get('Calendars');
        System.assertEquals(1, calendarsList.size());

        Map<String, Object> calendarData = (Map<String, Object>) calendarsList[0];
        System.assertEquals('Save', calendarData.get('Type'));
        System.assertEquals(true, calendarData.get('Tentative'));
        System.assertEquals(Date.valueOf('2023-01-15'), Date.valueOf(calendarData.get('MovingDate').toString()));
        System.assertEquals('Test Title', calendarData.get('Title'));

        List<Object> labelsList = (List<Object>) responseMap.get('Labels');
        System.assertEquals(1, labelsList.size());

        Map<String, Object> labelData = (Map<String, Object>) labelsList[0];
        System.assertEquals(1, (Integer)labelData.get('FriendCount'));
        System.assertEquals('TestLabel', labelData.get('Name'));
    }
  
}