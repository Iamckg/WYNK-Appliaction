trigger CreateNotificationForUsers on Notification__c (after insert, after update) {


    List<User_Notification__c> userNotificationList = new List<User_Notification__c>();
    List<Id> customerIds = new List<Id>();
    List<Customer__c> userIds = [SELECT Id, Name, Device_Token__c FROM Customer__c WHERE IsProfile__c = true AND IsDeleted__c = false];
    
    String NoticationMsg;

    for (Notification__c nt : Trigger.new) {

        if (!nt.All_Customer__c) {
        customerIds.add(nt.Customer__c);

        // Create User_Notificationc records as before
        User_Notification__c userNotification = new User_Notification__c();
        userNotification.Customer__c = nt.Customer__c; // Update to the new lookup field
        userNotification.Name = 'Admin notification';
        userNotification.SendFeedback__c = nt.Feedback__c;
        userNotification.Message__c = nt.Feedback__c
            ? 'How can we make this app better fit for you?'
            : nt.Notification_Text__c.replaceAll('<p>|</p>', '');

        userNotificationList.add(userNotification);
        NoticationMsg=  userNotification.Message__c ;   

    }else{
        for (Customer__c cust : userIds) {
                User_Notification__c userNotifications = new User_Notification__c();
                userNotifications.Customer__c = cust.Id;
                userNotifications.Name = 'Admin notification For ' + cust.Name;
                userNotifications.SendFeedback__c = nt.Feedback__c;
                userNotifications.Message__c = nt.Feedback__c
                    ? 'How can we make this app better fit for you?'
                    : nt.Notification_Text__c.replaceAll('<p>|</p>', '');

                userNotificationList.add(userNotifications);
                customerIds.add(cust.Id);
                NoticationMsg=  userNotifications.Message__c ; 
            }
    }


    // Insert all User_Notification__c records in a single DML operation
    if (!userNotificationList.isEmpty()) {
        insert userNotificationList;
    }

    // Call the future method to perform the callout
    if (!customerIds.isEmpty()) {
         NotificationCalloutHandler.notifyCustomers(customerIds, NoticationMsg);
    }
}


}