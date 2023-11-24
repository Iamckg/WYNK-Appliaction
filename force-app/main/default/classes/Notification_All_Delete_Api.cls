@RestResource(urlMapping='/NotificationAllDeleteApi/*')
global class Notification_All_Delete_Api {
    @HttpPost
    global static void DeleteNotifications(String UserId) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            List<User_Notification__c> NotificationRecords = [
                SELECT Id, Name
                FROM User_Notification__c
                WHERE Customer__r.Id = :UserId
            ];
            
            if (!NotificationRecords.isEmpty()) {
                // Delete all matching records
                delete NotificationRecords;
                
                response.put('Message', 'All Notifications for the User Successfully Deleted');
                response.put('Status', 'Success');
            } else {
                response.put('Message', 'No Notifications found for the User');
                response.put('Status', 'Success');
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