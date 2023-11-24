@RestResource(urlMapping='/GroupMemberIsAttend/*')
global class GroupMemberIsAttend {
    @HttpPost
    global static void MarkAsAttend(String GroupId, String MemberId) {
        Map<String, Object> response = new Map<String, Object>();
        List<String> NotificationIds = New List<String>();
        try {
            Group_Member__c memberToUpdate = [SELECT Id, Name, MemberId__c, IsJoined__c,Attend__c, isTentative__c, Pending__c, Declined__c, Group__c, Group__r.Name, Group__r.Customer__c
                FROM Group_Member__c WHERE MemberId__c = :MemberId AND Group__c = :GroupId];

            if (memberToUpdate != null) {
                memberToUpdate.isTentative__c = false;
                memberToUpdate.Attend__c = true;
                Update memberToUpdate;

                // Create a list of notifications
                List<User_Notification__c> notifications = new List<User_Notification__c>();

                // Notify the member who marked as tentative
                User_Notification__c userNotification1 = new User_Notification__c();
                userNotification1.Customer__c = MemberId;
                userNotification1.Name = 'Group Attend';
                userNotification1.Message__c = 'You have marked as Attend for the ' + memberToUpdate.Group__r.Name + ' Group';
                notifications.add(userNotification1);

                // Notify the group owner
                User_Notification__c groupOwnerNotification = new User_Notification__c();
                groupOwnerNotification.Customer__c = memberToUpdate.Group__r.Customer__c;
                groupOwnerNotification.Name = 'Group Request Attend';
                groupOwnerNotification.Message__c = 'Your group member ' + memberToUpdate.Name + ' has marked as Attend for the ' + memberToUpdate.Group__r.Name + ' Group';
                notifications.add(groupOwnerNotification);

                // Insert all notifications in a single DML operation
                Insert notifications;
                
                If(notifications!=null){
                    for(User_Notification__c record :notifications){
                        NotificationIds.add(record.Id);
                    }
                }
                
                response.put('message', 'You have marked as Attend successfully.');
                response.put('Status', 'Success');
                response.put('NotificationIds', NotificationIds);
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