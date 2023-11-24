@RestResource(urlMapping='/NoticationListAccordingUser/*')
global class Notification_List_According_User_Api {
    @HttpPost
    global static void CreateGroup(String UserId) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            List<Map<String, Object>> NotificationsList = new List<Map<String, Object>>();
            
            List<User_Notification__c> NotificationRecords = [
                SELECT Id, Name, IsRead__c, SendFeedback__c , CustomId__c,Message__c, Customer__r.Id 
                FROM User_Notification__c 
                WHERE Customer__r.Id = :UserId
            ];

            for (User_Notification__c record : NotificationRecords) {
                Map<String, Object> NotificationData = new Map<String, Object>();
                NotificationData.put('FeedBack', record.SendFeedback__c);
                NotificationData.put('SenderId', record.CustomId__c);
                NotificationData.put('Message', record.Message__c);
                NotificationData.put('IsRead', record.IsRead__c);
                NotificationData.put('Title', record.Name);
                NotificationData.put('NotificationId', record.ID);
                NotificationsList.add(NotificationData);
            }

            response.put('NotificationsList', NotificationsList);
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