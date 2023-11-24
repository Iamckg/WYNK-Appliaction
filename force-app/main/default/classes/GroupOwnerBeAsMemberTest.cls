@isTest
public class GroupOwnerBeAsMemberTest {
    @isTest
    static void testTrigger() {
        // Create a test customer
        Customer__c testCustomer = new Customer__c(
            Name = 'Test Customer',
            Last_Name__c = 'TestLastName',
            Phone__c = '1234567890'
        );
        insert testCustomer;

        // Create a test group
        Group__c testGroup = new Group__c(
            Name = 'Test Group',
            Customer__c = testCustomer.Id
        );
        insert testGroup;

        // Set up the test data for trigger execution
        List<Group__c> testGroups = new List<Group__c>{testGroup};

        // Test the trigger by inserting the test group
        Test.startTest();
        // Re-query the group to get the Id after insertion
        testGroup = [SELECT Id, Name, Customer__c FROM Group__c WHERE Id = :testGroup.Id LIMIT 1];
        
        // Create a new instance of Group Member without specifying the Id
        Group_Member__c insertedGroupMember = new Group_Member__c(
            Group__c = testGroup.Id,
            Name = testCustomer.Name,
            MemberId__c = testCustomer.Id,
            LastName__c = testCustomer.Last_Name__c,
            Role__c = 'Admin',
            Phone__c = testCustomer.Phone__c,
            IsJoined__c = true,
            Pending__c = false,
            isTentative__c = false
        );
        insert insertedGroupMember;
        Test.stopTest();

        // Query the Group Members to verify the insertion
        List<Group_Member__c> groupMembers = [SELECT Id, Group__c, Name, MemberId__c, LastName__c, Role__c, Phone__c, IsJoined__c, Pending__c, isTentative__c
                                              FROM Group_Member__c WHERE Group__c IN :testGroups];

        // Assert that the trigger has correctly inserted the Group Member record
        System.assertEquals(2, groupMembers.size());
        insertedGroupMember = groupMembers[0];
        System.assertEquals(testGroup.Id, insertedGroupMember.Group__c);
        System.assertEquals(testCustomer.Id, insertedGroupMember.MemberId__c);
        System.assertEquals('Admin', insertedGroupMember.Role__c);
        System.assertEquals('Test Customer', insertedGroupMember.Name);
        System.assertEquals('TestLastName', insertedGroupMember.LastName__c);
        System.assertEquals('1234567890', insertedGroupMember.Phone__c);
        System.assertEquals(true, insertedGroupMember.IsJoined__c);
        System.assertEquals(false, insertedGroupMember.Pending__c);
        System.assertEquals(false, insertedGroupMember.isTentative__c);

        // Clean up test data
        delete testGroups;
        delete testCustomer;
    }
}