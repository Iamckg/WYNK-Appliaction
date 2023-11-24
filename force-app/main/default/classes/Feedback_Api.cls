@RestResource(urlMapping='/feedback/*')
global class Feedback_Api {
    @HttpPost
    global static void completeProfile(String AccountId, String title, String description, String NotificationId) {
        Map<String, Object> response = new Map<String, Object>();

        try {  
            Feedback__c fb = new Feedback__c();
            if (String.isNotBlank(title)) {
               fb.Name = title;  
            }else{
               fb.Name = 'User Feedback'; 
            }
           
            fb.Description__c = description;
            fb.Customer__c = AccountId;
            insert fb;
            
            if (String.isNotBlank(NotificationId)) {
            User_Notification__c un =[Select Id from User_Notification__c Where Id =:NotificationId LIMIT 1];
            Delete un;
            }
            
            response.put('message', 'Your feedback is Successfully Sent.');
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