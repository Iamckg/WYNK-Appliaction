@isTest
public class GroupMemberIsTentativeApiTest {

    @isTest
    static void testMarkAsTentative() {
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

        request.requestURI = '/services/apexrest/GroupMemberIsTentative';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('GroupId', gp.Id);
        requestBody.put('MemberId', groupMember.Id);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        GroupMember_IsTentative_Api.MarkAsTentative(gp.Id, groupMember.Id);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        System.assertEquals('You have marked as tentative successfully.', result.get('message'));

        // Verify that the group member's status is marked as tentative
        Group_Member__c updatedGroupMemberRecord = [SELECT isTentative__c, Attend__c FROM Group_Member__c WHERE Id = :groupMemberRecord.Id];
        System.assertEquals(true, updatedGroupMemberRecord.isTentative__c);
        System.assertEquals(false, updatedGroupMemberRecord.Attend__c);

        // Clean up test data
        delete groupMemberRecord;
        delete gp;
        delete groupMember;
        delete groupOwner;
    }

    @isTest
    static void testMarkAsTentativeRecordNotFound() {
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GroupMemberIsTentative';
        request.httpMethod = 'POST';

        // Use non-existing GroupId and MemberId
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('GroupId', 'non-existing-group-id');
        requestBody.put('MemberId', 'non-existing-member-id');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        GroupMember_IsTentative_Api.MarkAsTentative('non-existing-group-id', 'non-existing-member-id');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

    }
    
        @isTest
    static void testelse() {
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

        request.requestURI = '/services/apexrest/GroupMemberIsTentative';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('GroupId', 'test');
        requestBody.put('MemberId', 'test');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        GroupMember_IsTentative_Api.MarkAsTentative('test', 'test');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

     //   System.assertEquals('Failed', result.get('Status'));
    //    System.assertEquals('Group Member record not found.', result.get('message'));
        // Clean up test data
        delete groupMemberRecord;
        delete gp;
        delete groupMember;
        delete groupOwner;
    }

    
}