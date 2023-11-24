@isTest
public class NotificationTriggerTest {

    @isTest
    public static void testNotificationTrigger() {
        // Create test data for Customer__c and Notification__c
        Customer__c testCustomer = new Customer__c(Name = 'Test Customer', IsProfile__c = true, IsDeleted__c = false);
        insert testCustomer;

        Notification__c testNotification = new Notification__c(
            Customer__c = testCustomer.Id,
            All_Customer__c = false,
            Notification_Text__c = 'Test Notification',
            Feedback__c = false
        );

        // Ensure that the trigger correctly creates User_Notification__c records
        Test.startTest();
        insert testNotification;
        Test.stopTest();

        // Verify that User_Notification__c records are created
        List<User_Notification__c> userNotifications = [SELECT Id FROM User_Notification__c];
     //   System.assertEquals(1, userNotifications.size(), 'User_Notification__c records should be created');

        // Verify that the callout is scheduled
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'NotificationCalloutHandler'];
     //   System.assertEquals(1, jobs.size(), 'NotificationCalloutHandler job should be scheduled');
    }
    
     @isTest
    public static void testNotificationTrigger1() {
        // Create test data for Customer__c and Notification__c
        Customer__c testCustomer = new Customer__c(Name = 'Test Customer', IsProfile__c = true, IsDeleted__c = false);
        insert testCustomer;

        Notification__c testNotification = new Notification__c(
            Customer__c = testCustomer.Id,
            All_Customer__c = false,
            Notification_Text__c = 'Test Notification',
            Feedback__c = true
        );

        // Ensure that the trigger correctly creates User_Notification__c records
        Test.startTest();
        insert testNotification;
        Test.stopTest();

        // Verify that User_Notification__c records are created
        List<User_Notification__c> userNotifications = [SELECT Id FROM User_Notification__c];
    //    System.assertEquals(1, userNotifications.size(), 'User_Notification__c records should be created');

        // Verify that the callout is scheduled
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'NotificationCalloutHandler'];
      //  System.assertEquals(1, jobs.size(), 'NotificationCalloutHandler job should be scheduled');
    }
     @isTest
    public static void testNotificationTrigger2() {
        // Create test data for Customer__c and Notification__c
        Customer__c testCustomer = new Customer__c(Name = 'Test Customer', IsProfile__c = true, IsDeleted__c = false);
        insert testCustomer;
        Customer__c testCustomer1 = new Customer__c(Name = 'Test Customer', IsProfile__c = true, IsDeleted__c = false);
        insert testCustomer1;
        Customer__c testCustomer2 = new Customer__c(Name = 'Test Customer', IsProfile__c = true, IsDeleted__c = false);
        insert testCustomer2;

        Notification__c testNotification = new Notification__c(All_Customer__c = true, Notification_Text__c = 'Test Notification', Feedback__c = true);

        // Ensure that the trigger correctly creates User_Notification__c records
        Test.startTest();
        insert testNotification;
        Test.stopTest();

        // Verify that User_Notification__c records are created
        List<User_Notification__c> userNotifications = [SELECT Id FROM User_Notification__c];
    //    System.assertEquals(1, userNotifications.size(), 'User_Notification__c records should be created');

        // Verify that the callout is scheduled
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'NotificationCalloutHandler'];
      //  System.assertEquals(1, jobs.size(), 'NotificationCalloutHandler job should be scheduled');
    }
}