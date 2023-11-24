@isTest
public class GroupMember_IsDeclined_ApiTest {
    @isTest
    static void testDeclineMembershipSuccess() {
        // Create a test group owner
        Customer__c groupOwner = new Customer__c(Name = 'Group Owner');
        insert groupOwner;

        // Create a test group
        Group__c testGroup = new Group__c(Name = 'Test Group', Customer__c = groupOwner.Id);
        insert testGroup;

        // Create a test group member
        Customer__c groupMember = new Customer__c(Name = 'Group Member');
        insert groupMember;

        Group_Member__c testMember = new Group_Member__c(
            Name = 'Test Member',
            MemberId__c = groupMember.Id,
            IsJoined__c = true,
            Group__c = testGroup.Id
        );
        insert testMember;

        // Create a test notification for the group member
        User_Notification__c testNotification = new User_Notification__c(
            Name = 'Test Notification',
            Customer__c = groupMember.Id,
            Message__c = 'You have a group membership request.'
        );
        insert testNotification;

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/GroupMemberIsDeclined';
        req.httpMethod = 'POST';

        // Define input parameters
        String groupId = testGroup.Id;
        String memberId = groupMember.Id;
        String notificationId = testNotification.Id;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('GroupId', groupId);
        requestBody.put('MemberId', memberId);
        requestBody.put('NotificationId', notificationId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test a successful decline membership request
        Test.startTest();
        GroupMember_IsDeclined_Api.DeclineMembership(groupId, memberId, notificationId);
        Test.stopTest();

        // Verify the response
        String responseBody = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

      //  System.assertEquals('Success', responseMap.get('Status'));

    //    List<String> notificationIds = (List<String>) responseMap.get('NotificationIds');
     //   System.assertEquals(2, notificationIds.size());
    }

    @isTest
    static void testDeclineMembershipFailure() {
        // Set up the REST request with an invalid group ID and member ID
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        req.requestURI = '/services/apexrest/GroupMemberIsDeclined';
        req.httpMethod = 'POST';

        // Define input parameters with invalid group ID and member ID
        String groupId = 'invalidGroupId';
        String memberId = 'invalidMemberId';
        String notificationId = null;

        // Create the JSON request body
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('GroupId', groupId);
        requestBody.put('MemberId', memberId);
        requestBody.put('NotificationId', notificationId);

        // Serialize the request body to JSON
        String jsonBody = JSON.serialize(requestBody);
        req.requestBody = Blob.valueOf(jsonBody);

        // Test a failed decline membership request
        Test.startTest();
        GroupMember_IsDeclined_Api.DeclineMembership(groupId, memberId, notificationId);
        Test.stopTest();

        // Verify the response
        String responseBody = res.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Failed', responseMap.get('Status'));
    }
}