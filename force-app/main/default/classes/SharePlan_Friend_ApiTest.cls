@isTest
public class SharePlan_Friend_ApiTest {
   @isTest
    static void testAddMembersSuccess() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;

        // Create a test friend user
        Customer__c friendUser = new Customer__c(Name = 'FriendUser');
        insert friendUser;

        Test.startTest();
        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/SharePlanFriend';
        req.httpMethod = 'POST';

        // Define input parameters
        String userId = testUser.Id;
        List<String> memberIds = new List<String>{friendUser.Id}; // Use a list of strings

        // Create the JSON request body
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('UserId', userId);
        requestBody.put('MemberIds', memberIds);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test a successful friend request
        SharePlan_Friend_Api.AddMembers(userId, memberIds);
        Test.stopTest();

        // Verify the response
        String responseBody = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

     //   System.assertEquals('Success', responseMap.get('Status'));
     //   System.assertEquals('Successfully Sent Friend Requests.', responseMap.get('message'));

     //   List<String> notificationIds = (List<String>) responseMap.get('NotificationIds');
      //  System.assertEquals(1, notificationIds.size());
    }
    @isTest
    static void testAddMembersFriendRequestSent() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;

        // Create a test friend user
        Customer__c friendUser = new Customer__c(Name = 'FriendUser');
        insert friendUser;

        // Create a User_Notification__c record with a sent friend request
        User_Notification__c notification = new User_Notification__c(
            Name = 'Friend Request',
            Customer__c = friendUser.Id,
            CustomId__c = testUser.Id,
            IsFriendRequestSend__c = true
        );
        insert notification;

        Test.startTest();
        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/SharePlanFriend';
        req.httpMethod = 'POST';

        // Define input parameters
        String userId = testUser.Id;
        List<String> memberIds = new List<String>{friendUser.Id};

        // Create the JSON request body
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('UserId', userId);
        requestBody.put('MemberIds', memberIds);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test a case where a friend request has already been sent
        SharePlan_Friend_Api.AddMembers(userId, memberIds);
        Test.stopTest();

        // Verify the response
        String responseBody = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', responseMap.get('Status'));
        System.assertEquals('Friend Requests Already Sent to These Users.', responseMap.get('message'));
    }

    @isTest
    static void testAddMembersInvalidUser() {
        // Create a test user
        Customer__c testUser = new Customer__c(Name = 'TestUser');
        insert testUser;

        Test.startTest();
        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/SharePlanFriend';
        req.httpMethod = 'POST';

        // Define input parameters with an invalid memberId (user does not exist)
        String userId = testUser.Id;
        List<String> memberIds = new List<String>{'invalidUserId'};

        // Create the JSON request body
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('UserId', userId);
        requestBody.put('MemberIds', memberIds);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test a case where an invalid member is specified
        SharePlan_Friend_Api.AddMembers(userId, memberIds);
        Test.stopTest();

        // Verify the response
        String responseBody = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Failed', responseMap.get('Status'));
     //   System.assertEquals('Friend not found.', responseMap.get('message'));
    }
}