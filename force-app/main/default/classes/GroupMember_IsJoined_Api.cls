@RestResource(urlMapping='/GroupMemberIsJoined/*')
global class GroupMember_IsJoined_Api {
    @HttpPost
    global static void AddMembers(String GroupId, String MemberId, String NotificationId) {
        Map<String, Object> response = new Map<String, Object>();
        List<String> NotificationIds = New List<String>();
        try {
            // Query the Group Member record
            Group_Member__c memberToUpdate = [SELECT Id, Name, MemberId__c, Attend__c ,IsJoined__c, isTentative__c, Pending__c, Declined__c, Group__c, Group__r.Name, Group__r.Customer__c
                FROM Group_Member__c WHERE MemberId__c = :MemberId AND Group__c = :GroupId];

            if (memberToUpdate != null) {
                memberToUpdate.Declined__c = false;
                memberToUpdate.IsJoined__c = true;
                memberToUpdate.Attend__c = false;
                memberToUpdate.Pending__c = false;
                memberToUpdate.isTentative__c = true;
                Update memberToUpdate;
                
                if (String.isNotBlank(NotificationId)) {
                User_Notification__c notificat = [SELECT Id FROM User_Notification__c WHERE Id = :NotificationId LIMIT 1];
                Delete notificat;
                }
                // Notify the member who joined
                User_Notification__c userNotification = new User_Notification__c();
                userNotification.Customer__c = MemberId;
                userNotification.Name = 'Group joined';
                userNotification.Message__c = 'You successfully joined the ' + memberToUpdate.Group__r.Name + ' Group';
                Insert userNotification;
                NotificationIds.add(userNotification.Id);
                
                // Notify the group owner
                User_Notification__c groupOwnerNotification = new User_Notification__c();
                groupOwnerNotification.Customer__c = memberToUpdate.Group__r.Customer__c;
                groupOwnerNotification.Name = 'Group Request Accepted';
                groupOwnerNotification.Message__c = 'Your group member ' + memberToUpdate.Name + ' has successfully joined the ' + memberToUpdate.Group__r.Name + ' Group';
                Insert groupOwnerNotification;
                NotificationIds.add(groupOwnerNotification.Id);
                
                response.put('message', 'You are successfully joined.');
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