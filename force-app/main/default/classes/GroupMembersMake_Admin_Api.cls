@RestResource(urlMapping='/GroupMembersMakeAdmin/*')
global class GroupMembersMake_Admin_Api {
    @HttpPost
    global static void MakeGroupAdmin(String GroupId, String MemberId) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            // Query the group member you want to make an admin
            Group_Member__c member = [SELECT Id, Name, MemberId__c,IsJoined__c, isTentative__c,Attend__c,Role__c, Group__c, Group__r.Name FROM Group_Member__c
                                      WHERE Group__c = :GroupId AND MemberId__c = :MemberId LIMIT 1];
                                      
            if (member.IsJoined__c) {
                // Check if the member is not already an admin to avoid unnecessary updates
                if (member.Role__c != 'Admin') {
                    member.Role__c = 'Admin';
                    member.isTentative__c = false;
                    member.Attend__c = false;
                    Update member;
                    response.put('Message', 'Member ' + member.Name + ' is now a group Admin.');
                    response.put('Status', 'Success');
                    
                    User_Notification__c UserNotification = New User_Notification__c();
                    UserNotification.Customer__c=Member.MemberId__c;
                    UserNotification.Name='Group Amin';
                    UserNotification.Message__c= 'Now You Are Become a Group Admin Of ' +member.Group__r.Name;
                    Insert UserNotification;
                    response.put('NotificationIds', UserNotification.Id);
                } else {
                    response.put('Message', 'Member ' + member.Name + ' is already a group Admin.');
                    response.put('Status', 'Success');
                }
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