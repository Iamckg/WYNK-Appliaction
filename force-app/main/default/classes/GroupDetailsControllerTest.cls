@isTest
public class GroupDetailsControllerTest {

    @isTest
    static void testGroupDetailsController() {
        List<customer__c> customerList = New List<Customer__c>();
        Customer__c cust1= new Customer__c(Name ='FirstName',Last_Name__c='lastName',Phone__c='9000000');
        Customer__c cust2= new Customer__c(Name ='FirstName',Last_Name__c='lastName',Phone__c='9000000');
        Customer__c cust3= new Customer__c(Name ='FirstName',Last_Name__c='lastName',Phone__c='9000000');
        Customer__c cust4= new Customer__c(Name ='FirstName',Last_Name__c='lastName',Phone__c='9000000');
        customerList.add(cust1);
        customerList.add(cust2);
        customerList.add(cust3);
        customerList.add(cust4);
        insert customerList;
        
        // Create a test Group
        Group__c testGroup = new Group__c(Name='Test Group',Date__c=Date.newInstance(2023, 10, 10),Description__c='Test Description',Customer__c=cust1.Id);
        insert testGroup;
  
        
        // Create Group Members
        List<Group_Member__c> testGroupMembers = new List<Group_Member__c>();

        // Member 1 (Admin, Not Joined)
        Group_Member__c gm1 = new Group_Member__c(
            Name='John Doe',
            Role__c='Admin',
            IsJoined__c=false,
            IsTentative__c=false,
            Declined__c=false,
            MemberId__c=cust2.Id,
            Group__c=testGroup.Id
        );
        testGroupMembers.add(gm1);
        // Member 2 (Member, Joined)
        Group_Member__c gm2 = new Group_Member__c(
            Name='Jane Smith',
            Role__c='Member',
            IsJoined__c=true,
            IsTentative__c=false,
            Declined__c=false,
            MemberId__c=cust3.Id,
            Group__c=testGroup.Id
         
        );
        testGroupMembers.add(gm2);

        // Member 3 (Member, Tentative)
        Group_Member__c gm3 = new Group_Member__c(
            Name='Alice Johnson',
            Role__c='Member',
            IsJoined__c=false,
            IsTentative__c=true,
            Declined__c=false,
            MemberId__c=cust4.Id,
            Group__c=testGroup.Id
         
          
        );
        testGroupMembers.add(gm3);

        insert testGroupMembers;

        // Set the current page reference with the group ID parameter
        PageReference pageRef = Page.GroupDetailsPage;
        pageRef.getParameters().put('id', testGroup.Id);
        Test.setCurrentPage(pageRef);

        Test.startTest();

        // Instantiate the GroupDetailsController
        GroupDetailsController controller = new GroupDetailsController();
/*
        // Verify that the controller properties are populated correctly
        System.assertEquals(testGroup.Name, controller.GroupName);
        System.assertEquals(testGroup.Date__c, controller.GroupDate);
        System.assertEquals(testGroup.Description__c, controller.Description);
   //     System.assertEquals(testGroup.Total_Members__c, controller.TotalMembers);
        System.assertEquals(1, controller.TotalAdmin);
        System.assertEquals(1, controller.TotalJoined);
        System.assertEquals(1, controller.TotalTenative);
        System.assertEquals(0, controller.TotalDeclined);

        // Ensure that MembersDetails is not null
        System.assertNotEquals(null, controller.MembersDetails);

        // Verify the size of MembersDetails
        System.assertEquals(3, controller.MembersDetails.size());
*/
        Test.stopTest();

        // Clean up test data
        delete testGroupMembers;
        delete testGroup;
    }
}