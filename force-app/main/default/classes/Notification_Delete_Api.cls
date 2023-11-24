@RestResource(urlMapping='/NotificationDeleteApi/*')
global class Notification_Delete_Api {
    @HttpPost
    global static void DeleteNotifications(String UserId, String NotificationId) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            User_Notification__c NotificationRecords = [ SELECT Id, Name FROM User_Notification__c
                WHERE Customer__r.Id = :UserId  AND Id =:NotificationId ];

                // Delete  matching records
                delete NotificationRecords;
                
                response.put('Message', ' Your Notification for the User Successfully Deleted');
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