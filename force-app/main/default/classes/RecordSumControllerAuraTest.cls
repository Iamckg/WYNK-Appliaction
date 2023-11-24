@isTest
public class RecordSumControllerAuraTest {

    @isTest
    static void testGetUserCount() {
        // Create test data - replace this with your own test data setup
        List<Customer__c> users = new List<Customer__c>();
        Customer__c customer1 = new Customer__c(Name='Test1',Last_Name__c= 'Last Name',Phone__c='9000000',IsProfile__c = true, IsDeleted__c = false);
        users.add(customer1);
        Customer__c customer2 = new Customer__c(Name='Test2',Last_Name__c= 'Last Name',Phone__c='9000000',IsProfile__c = true, IsDeleted__c = false);
        users.add(customer2);
        Customer__c customer3 = new Customer__c(Name='Test2',Last_Name__c= 'Last Name',Phone__c='9000000',IsProfile__c = false, IsDeleted__c = True);
        users.add(customer3);
     
        insert users;

        // Call the method and assert the result
        Test.startTest();
        Integer userCount = RecordSumControllerAura.getUserCount();
        Test.stopTest();

        // Assert that the method returned the expected count
        System.assertEquals(2, userCount);
    }

    @isTest
    static void testGetBannerCount() {
        // Create test data - replace this with your own test data setup
        List<Banner__c> banners = new List<Banner__c>();
        Banner__c banner1 = New Banner__c(Name='Test1');
        banners.add(banner1);
        Banner__c banner2 = New Banner__c(Name='Test2');
        banners.add(banner2);
        Banner__c banner3 = New Banner__c(Name='Test3');
        banners.add(banner3);
       
        insert banners;

        // Call the method and assert the result
        Test.startTest();
        Integer bannerCount = RecordSumControllerAura.getBannerCount();
        Test.stopTest();

        // Assert that the method returned the expected count
        System.assertEquals(3, bannerCount);
    }

    @isTest
    static void testGetEmailCount() {
        // Create test data - replace this with your own test data setup
        List<Email_Template__c> emailTemplates = new List<Email_Template__c>();
        Email_Template__c emailTemplate1 = New Email_Template__c(Name='Test1', Email_Subject__c='test subject', Email_Body__c='Test body');
        emailTemplates.add(emailTemplate1);
        Email_Template__c emailTemplate2 = New Email_Template__c(Name='Test2', Email_Subject__c='test subject', Email_Body__c='Test body');
        emailTemplates.add(emailTemplate2);
        Email_Template__c emailTemplate3 = New Email_Template__c(Name='Test3', Email_Subject__c='test subject', Email_Body__c='Test body');
        emailTemplates.add(emailTemplate3);
        
        insert emailTemplates;

        // Call the method and assert the result
        Test.startTest();
        Integer emailCount = RecordSumControllerAura.getEmailCount();
        Test.stopTest();

        // Assert that the method returned the expected count
        System.assertEquals(3, emailCount);
    }
/*
    @isTest
    static void testGetNotificationCount() {
        
        Customer__c cust = New Customer__c(Name ='Test', Last_Name__c ='LastName');
        Insert cust;
        // Create test data - replace this with your own test data setup
        List<Notification__c> notifications = new List<Notification__c>();
        
        Notification__c notification1 = New Notification__c(Feedback__c=true,All_Customer__c= true,Customer__c=cust.Id,Notification_Text__c='test');
        notifications.add(notification1);
        
        Notification__c notification2 = New Notification__c(Feedback__c=true, All_Customer__c= false,Customer__c=cust.Id,Notification_Text__c='test');
        notifications.add(notification2);
        
        Notification__c notifiaction3 = New Notification__c(Feedback__c=false ,All_Customer__c= true,Customer__c=cust.Id,Notification_Text__c='test') ;
        notifications.add(notifiaction3);
        
        insert notifications;

        // Call the method and assert the result
        Test.startTest();
        Integer notificationCount = RecordSumControllerAura.getNotificationCount();
        Test.stopTest();

        // Assert that the method returned the expected count
        System.assertEquals(3, notificationCount);
    }
*/
}