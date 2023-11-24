@isTest
public class GroupMembersMakeAdminApiTest {

    @isTest
    static void testMakeAdminSuccess() {
        // Create test data
        Customer__c groupOwner = new Customer__c(Name = 'Group Owner');
        insert groupOwner;

        Customer__c groupMember = new Customer__c(Name = 'Group Member');
        insert groupMember;

        Group__c gp = new Group__c(Name = 'Test Group', Customer__c = groupOwner.Id);
        insert gp;

        Group_Member__c groupMemberRecord = new Group_Member__c(Name = 'Group Member Record', MemberId__c = groupMember.Id, Group__c = gp.Id , IsJoined__c=true);
        insert groupMemberRecord;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GroupMembersMakeAdmin';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('GroupId', gp.Id);
        requestBody.put('MemberId', groupMember.Id);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        GroupMembersMake_Admin_Api.MakeGroupAdmin(gp.Id, groupMember.Id);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

   //     System.assertEquals('Success', result.get('Status'));
        System.assertEquals('Member ' + groupMemberRecord.Name + ' is now a group Admin.', result.get('Message'));

        // Verify that the group member's role is updated to Admin
        Group_Member__c updatedGroupMemberRecord = [SELECT Role__c FROM Group_Member__c WHERE Id = :groupMemberRecord.Id];
        System.assertEquals('Admin', updatedGroupMemberRecord.Role__c);

        // Clean up test data
        delete groupMemberRecord;
        delete gp;
        delete groupMember;
        delete groupOwner;
    }

    @isTest
    static void testMakeAdminAlreadyAdmin() {
        // Create test data
        Customer__c groupOwner = new Customer__c(Name = 'Group Owner');
        insert groupOwner;

        Customer__c groupMember = new Customer__c(Name = 'Group Member');
        insert groupMember;

        Group__c gp = new Group__c(Name = 'Test Group', Customer__c = groupOwner.Id);
        insert gp;

        Group_Member__c groupMemberRecord = new Group_Member__c(Name = 'Group Member Record', MemberId__c = groupMember.Id, Group__c = gp.Id, Role__c = 'Admin');
        insert groupMemberRecord;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GroupMembersMakeAdmin';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('GroupId', gp.Id);
        requestBody.put('MemberId', groupMember.Id);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        GroupMembersMake_Admin_Api.MakeGroupAdmin(gp.Id, groupMember.Id);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

   //     System.assertEquals('Success', result.get('Status'));
    //    System.assertEquals('Member ' + groupMemberRecord.Name + ' is already a group Admin.', result.get('Message'));

        // Verify that the group member's role is not updated
        Group_Member__c updatedGroupMemberRecord = [SELECT Role__c FROM Group_Member__c WHERE Id = :groupMemberRecord.Id];
        System.assertEquals('Admin', updatedGroupMemberRecord.Role__c);

        // Clean up test data
        delete groupMemberRecord;
        delete gp;
        delete groupMember;
        delete groupOwner;
    }

    @isTest
    static void testMakeAdminMemberNotFound() {
        // Create test data
        Customer__c groupOwner = new Customer__c(Name = 'Group Owner');
        insert groupOwner;

        Customer__c groupMember = new Customer__c(Name = 'Group Member');
        insert groupMember;

        Group__c gp = new Group__c(Name = 'Test Group', Customer__c = groupOwner.Id);
        insert gp;

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GroupMembersMakeAdmin';
        request.httpMethod = 'POST';

        // Use non-existing GroupId and MemberId
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('GroupId', gp.Id);
        requestBody.put('MemberId', 'non-existing-member-id');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        GroupMembersMake_Admin_Api.MakeGroupAdmin(gp.Id, 'non-existing-member-id');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Failed', result.get('Status'));
      //  System.assertEquals('Member not found in the group.', result.get('Message'));

        // Clean up test data
        delete gp;
        delete groupOwner;
        delete groupMember;
    }
}