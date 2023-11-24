@isTest
public class GroupMemberIsJoinedApiTest {

    @isTest
    static void testAddMembersSuccess() {
        // Create test data
        Customer__c groupOwner = new Customer__c(Name = 'Group Owner');
        insert groupOwner;

        Customer__c groupMember = new Customer__c(Name = 'Group Member');
        insert groupMember;

        Group__c gp = new Group__c(Name = 'Test Group', Customer__c = groupOwner.Id);
        insert gp;

        Group_Member__c groupMemberRecord = new Group_Member__c(Name = 'Group Member Record', MemberId__c = groupMember.Id, Group__c = gp.Id);
        insert groupMemberRecord;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GroupMemberIsJoined';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('GroupId', gp.Id);
        requestBody.put('MemberId', groupMember.Id);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        GroupMember_IsJoined_Api.AddMembers(gp.Id, groupMember.Id, '');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        System.assertEquals('You are successfully joined.', result.get('message'));

        // Verify that the group member's status is updated
        Group_Member__c updatedGroupMemberRecord = [SELECT IsJoined__c, Attend__c, Pending__c, Declined__c FROM Group_Member__c WHERE Id = :groupMemberRecord.Id];
        System.assertEquals(true, updatedGroupMemberRecord.IsJoined__c);
        System.assertEquals(false, updatedGroupMemberRecord.Attend__c);
        System.assertEquals(false, updatedGroupMemberRecord.Pending__c);
        System.assertEquals(false, updatedGroupMemberRecord.Declined__c);

        // Clean up test data
        delete groupMemberRecord;
        delete gp;
        delete groupMember;
        delete groupOwner;
    }

    @isTest
    static void testAddMembersRecordNotFound() {
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GroupMemberIsJoined';
        request.httpMethod = 'POST';

        // Use non-existing GroupId and MemberId
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('GroupId', 'non-existing-group-id');
        requestBody.put('MemberId', 'non-existing-member-id');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        GroupMember_IsJoined_Api.AddMembers('non-existing-group-id', 'non-existing-member-id', '');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Failed', result.get('Status'));
       // System.assertEquals('Group Member record not found.', result.get('message'));
    }
}