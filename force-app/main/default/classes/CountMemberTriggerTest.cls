@isTest
public class CountMemberTriggerTest {

    @isTest
    static void testTrigger() {
        List<Customer__c> customerList = new List<Customer__c>();
        Customer__c customer1 = new Customer__c(Name='test1', Last_Name__c='customer1', Phone__c='9000001');
        Customer__c customer2 = new Customer__c(Name='test2', Last_Name__c='customer2', Phone__c='9000002');
        Customer__c customer3 = new Customer__c(Name='test3', Last_Name__c='customer3', Phone__c='9000003');
        Customer__c customer4 = new Customer__c(Name='test4', Last_Name__c='customer4', Phone__c='9000004');
        customerList.add(customer1);
        customerList.add(customer2);
        customerList.add(customer3);
        customerList.add(customer4);
        insert customerList;
        
        // Create a test group
        Group__c testGroup = new Group__c(Name='Test Group', Customer__c=customer1.Id);
        insert testGroup;

        // Create test group members
        List<Group_Member__c> testMembers = new List<Group_Member__c>();
        Group_Member__c gm1 = new Group_Member__c(Name=customer2.Name, LastName__c=customer2.Last_Name__c, Group__c=testGroup.Id);
        Group_Member__c gm2 = new Group_Member__c(Name=customer3.Name, LastName__c=customer3.Last_Name__c, Group__c=testGroup.Id);
        Group_Member__c gm3 = new Group_Member__c(Name=customer4.Name, LastName__c=customer4.Last_Name__c, Group__c=testGroup.Id);
        testMembers.add(gm1);
        testMembers.add(gm2);
        testMembers.add(gm3);
        insert testMembers;

        // Verify that the trigger correctly updates the Total_Members__c field
        testGroup = [SELECT Id, Total_Members__c FROM Group__c WHERE Id = :testGroup.Id LIMIT 1];
        System.assertEquals(4, Integer.valueOf(testGroup.Total_Members__c));

        // Update one group member
        gm1.IsJoined__c = true;
        update gm1;

        // Verify the Total_Members__c field is updated
        testGroup = [SELECT Id, Total_Members__c FROM Group__c WHERE Id = :testGroup.Id LIMIT 1];
        System.assertEquals(4, Integer.valueOf(testGroup.Total_Members__c));

        // Delete one group member
        delete gm2;

        // Verify the Total_Members__c field is updated
        testGroup = [SELECT Id, Total_Members__c FROM Group__c WHERE Id = :testGroup.Id LIMIT 1];
        System.assertEquals(3, Integer.valueOf(testGroup.Total_Members__c));

        // Undelete the deleted group member
        undelete gm2;

        // Verify the Total_Members__c field is updated
        testGroup = [SELECT Id, Total_Members__c FROM Group__c WHERE Id = :testGroup.Id LIMIT 1];
        System.assertEquals(4, Integer.valueOf(testGroup.Total_Members__c));

        // Clean up test data
        delete testMembers;
        delete testGroup;
    }
}