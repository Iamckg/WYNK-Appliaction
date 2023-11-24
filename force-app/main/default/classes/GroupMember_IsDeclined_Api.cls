@RestResource(urlMapping='/GroupMemberIsDeclined/*')
global class GroupMember_IsDeclined_Api {
    @HttpPost
    global static void DeclineMembership(String GroupId, String MemberId , String NotificationId) {
        Map<String, Object> response = new Map<String, Object>();
        List<String> NotificationIdss = New List<String>();
        try {
            Group_Member__c memberToUpdate = [SELECT Id, Name, MemberId__c, IsJoined__c, isTentative__c, Pending__c, Declined__c, Group__c, Group__r.Name, Group__r.Customer__c
                FROM Group_Member__c WHERE MemberId__c = :MemberId AND Group__c = :GroupId];

            if (memberToUpdate != null) {
                memberToUpdate.Declined__c = true;
                memberToUpdate.IsJoined__c = false;
                memberToUpdate.Pending__c = false;
                Update memberToUpdate;
                
                if (String.isNotBlank(NotificationId)) {
                User_Notification__c notificat = [SELECT Id FROM User_Notification__c WHERE Id = :NotificationId LIMIT 1];
                Delete notificat;
                }
                
                // Create a list of notifications
                List<User_Notification__c> notifications = new List<User_Notification__c>();

                // Notify the member who Declined
                User_Notification__c userNotification1 = new User_Notification__c();
                userNotification1.Customer__c = MemberId;
                userNotification1.Name = 'Group Declined';
                userNotification1.Message__c = 'You have Declined the ' + memberToUpdate.Group__r.Name + ' Group';
                notifications.add(userNotification1);

                // Notify the group owner
                User_Notification__c groupOwnerNotification = new User_Notification__c();
                groupOwnerNotification.Customer__c = memberToUpdate.Group__r.Customer__c;
                groupOwnerNotification.Name = 'Group Request Declined';
                groupOwnerNotification.Message__c = 'Your group member ' + memberToUpdate.Name + ' is Declined the ' + memberToUpdate.Group__r.Name + ' Group';
                notifications.add(groupOwnerNotification);

                // Insert all notifications in a single DML operation
                Insert notifications;
              
                If(notifications!= null){
                    for(User_Notification__c record :notifications){
                        NotificationIdss.add(record.Id);
                    }
                }
                
                response.put('message', 'You have successfully Declined.');
                response.put('Status', 'Success');
                response.put('NotificationIds', NotificationIdss);
            } else {
                response.put('message', 'Group Member record not found.');
                response.put('Status', 'Failed');
            }
        } catch (Exception ex) {
            response.put('Status', 'Failed');
            response.put('message', ex.getMessage());
        }

        String jsonResponse = JSON.serialize(response);

        // Return the JSON response
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonResponse);
    }
}