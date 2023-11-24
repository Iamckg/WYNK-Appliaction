@RestResource(urlMapping='/SharePlanFriend/*')
global class SharePlan_Friend_Api {
    @HttpPost
    global static void AddMembers(String UserId, List<String> MemberIds) {
        Map<String, Object> response = new Map<String, Object>();
        List<String> NotificationIds = New List<String>();
        try {
            // Query existing Friend__c records for the specified user
            Set<String> existingFriendNames = new Set<String>();

            List<Friend__c> existingFriends = [SELECT Name FROM Friend__c WHERE Customer__c = :UserId];
            for (Friend__c existingFriend : existingFriends) {
                existingFriendNames.add(existingFriend.Name);
            }

            List<User_Notification__c> userNotificationList = new List<User_Notification__c>();

            for (String memberId : MemberIds) {
                // Check if a Friend__c record with the same Name already exists
                if (!existingFriendNames.contains(memberId) && !UserId.equals(memberId)) {
                    // Check if a User_Notification__c record with the same Customer__c already exists
                    User_Notification__c existingNotification = getExistingNotification(UserId, memberId);

                    if (existingNotification == null) {
                        // Create a new User_Notification__c record
                        Customer__c customer = [SELECT Id, Name FROM Customer__c WHERE Id = :UserId];
                        User_Notification__c userNotification = new User_Notification__c();
                        userNotification.Customer__c = memberId;
                        userNotification.Name = 'Friend Request';
                        userNotification.IsFriendRequestSend__c = true;
                        userNotification.CustomId__c = UserId;
                        userNotification.Message__c = customer.Name + ' has sent you a friend request';

                        userNotificationList.add(userNotification);
                    } else if (!existingNotification.IsFriendRequestSend__c) {
                        // Update the existing User_Notification__c record
                        existingNotification.IsFriendRequestSend__c = true;
                        userNotificationList.add(existingNotification);
                    }
                }
            }

            if (!userNotificationList.isEmpty()) {
                Insert userNotificationList;
                for(User_Notification__c record:userNotificationList){
                    NotificationIds.add(record.Id);
                }
                response.put('message', 'Successfully Sent Friend Requests.');
            } else {
                response.put('message', 'Friend Requests Already Sent to These Users.');
            }

            response.put('Status', 'Success');
             response.put('NotificationIds', NotificationIds);
        } catch (Exception ex) {
            response.put('Status', 'Failed');
            response.put('message', ex.getMessage());
        }

        String jsonResponse = JSON.serialize(response);

        // Return the JSON response
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonResponse);
    }

    // Helper method to get the existing User_Notification__c record
    private static User_Notification__c getExistingNotification(String userId, String memberId) {
        List<User_Notification__c> notifications = [SELECT Id, IsFriendRequestSend__c FROM User_Notification__c
                                                    WHERE Customer__c = :memberId AND CustomId__c = :userId LIMIT 1];
        if (!notifications.isEmpty()) {
            return notifications[0];
        }
        return null;
    }
}