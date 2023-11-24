@RestResource(urlMapping='/NotificationReadUnReadApi/*')
global class Notification_Read_UnRead_Api {
    @HttpPost
    global static void MarkNotificationReadUnread(String UserId, String NotificationId, Boolean IsRead) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            User_Notification__c NotificationRecord = [SELECT Id, Name, IsRead__c, Message__c, Customer__r.Id 
                FROM User_Notification__c WHERE Customer__r.Id = :UserId AND Id = :NotificationId LIMIT 1];

            if (NotificationRecord != null) {
                NotificationRecord.IsRead__c = IsRead;
                Update NotificationRecord;

                response.put('UserId', NotificationRecord.Customer__r.Id);
                response.put('Message', NotificationRecord.Message__c);
                response.put('IsRead', NotificationRecord.IsRead__c);
                response.put('Title', NotificationRecord.Name);
                response.put('NotificationId', NotificationRecord.Id);

                if (IsRead) {
                    response.put('Message', 'Your Notification is Successfully Marked as Read');
                } else {
                    response.put('Message', 'Your Notification is Successfully Marked as Unread');
                }

                response.put('Status', 'Success');
            } else {
                response.put('Status', 'Failed');
                response.put('message', 'Notification not found');
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