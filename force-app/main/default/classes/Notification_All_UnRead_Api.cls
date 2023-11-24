@RestResource(urlMapping='/NotificationAllUnReadApi/*')
global class Notification_All_UnRead_Api {
    @HttpPost
    global static void MarkAllNotificationsAsRead(String UserId, Boolean IsRead) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            // Query all notifications for the specified user
            List<User_Notification__c> NotificationRecords = [
                SELECT Id, Name, IsRead__c
                FROM User_Notification__c
                WHERE Customer__r.Id = :UserId
            ];

            for (User_Notification__c notification : NotificationRecords) {
                notification.IsRead__c = IsRead;
            }

            // Update all notifications to mark them as Unread
            update NotificationRecords;

            response.put('Message', 'All Notifications for the User Successfully Marked as UnRead');
            response.put('Status', 'Success');
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