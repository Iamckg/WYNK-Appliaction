@RestResource(urlMapping='/GroupMembersLeave/*')
global class GroupMembersLeave_Api {
    @HttpPost
    global static void LeaveGroup(String GroupId, String MemberId) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            // Query the group member you want to remove from the group
            Group_Member__c member = [SELECT Id, Name, MemberId__c, Role__c, Group__c, Group__r.Name
                                      FROM Group_Member__c
                                      WHERE Group__c = :GroupId AND MemberId__c = :MemberId LIMIT 1];
                                      
            if (member != null) {
                // Record the group name for the notification
                String groupName = member.Group__r.Name;
                
                // Delete the member from the group
                Delete member;

                // Notify the member about leaving the group
                User_Notification__c userNotification = new User_Notification__c();
                userNotification.Customer__c = MemberId;
                userNotification.Name = 'Group Member';
                userNotification.Message__c = 'You have left the ' + groupName + ' Group';
                Insert userNotification;

                response.put('Message', 'You have left the ' + groupName + ' Group.');
                response.put('Status', 'Success');
            } else {
                response.put('Message', 'Member not found in the group.');
                response.put('Status', 'Failed');
            }
        } catch (Exception ex) {
            response.put('Message', ex.getMessage());
            response.put('Status', 'Failed');
        }
        
        String jsonResponse = JSON.serialize(response);

        // Return the JSON response
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonResponse);
    }
}