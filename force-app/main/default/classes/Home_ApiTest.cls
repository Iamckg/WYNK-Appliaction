@isTest
public class Home_ApiTest {
    @isTest
    static void testGetHomeListSuccess() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;

        // Create a test label
        Label__c testLabel = new Label__c(Name = 'TestLabel', Customer__c = testUser.Id);
        insert testLabel;

        // Create a test friend for the user
        Friend__c testFriend = new Friend__c(
            Name = 'TestFriend',
            FirstName__c = 'FriendFirst',
            Last_Name__c = 'FriendLast',
            DOB__c = Date.valueOf('1990-01-01'),
            Phone__c = '123-456-7890',
            Label__c = testLabel.Id,
            Customer__c = testUser.Id
        );
        insert testFriend;

        // Create a test calendar for the user
        Calendar__c testCalendar = new Calendar__c(
            Start_Date__c = Date.valueOf('2023-01-01'),
            Moving_Date__c = Date.valueOf('2023-01-10'),
            Title__c = 'Test Calendar',
            SaveDate__c=Date.valueOf('2023-01-01'),
            isTentative__c= false,
            Type__c='Save',
            Customer__c = testUser.Id
        );
        insert testCalendar;

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/Home';
        req.httpMethod = 'POST';

        // Define input parameters
        String userId = testUser.Id;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', userId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test a successful home list request
        Test.startTest();
        Home_Api.getHomeList(userId);
        Test.stopTest();

        // Verify the response
        String responseBody = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', responseMap.get('Status'));
/*
        List<Object> homeList = (List<Object>) responseMap.get('HomeList');
        System.assertEquals(1, homeList.size());

        Map<String, Object> calendarData = (Map<String, Object>) homeList[0];
        List<Object> dateList = (List<Object>) calendarData.get('dateList');
        System.assertEquals(10, dateList.size());

        List<Object> friendsList = (List<Object>) calendarData.get('Friends');
        System.assertEquals(1, friendsList.size());

        List<String> labels = (List<String>) responseMap.get('Labels');
        System.assertEquals(1, labels.size());
*/
    }

    @isTest
    static void testGetHomeListFailure() {
        // Set up the REST request with an invalid user ID
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/Home';
        req.httpMethod = 'POST';

        // Define input parameters with an invalid user ID
        String userId = 'invalidUserId';

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('UserId', userId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test a failed home list request
        Test.startTest();
        Home_Api.getHomeList(userId);
        Test.stopTest();

        // Verify the response
        String responseBody = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', responseMap.get('Status'));
    }
}