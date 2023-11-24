@RestResource(urlmapping='/saveDate/*')
global class Save_Date_Api {
    @HttpPost
    global static void UpdateCalendar(String UserId, String SaveDate, String title, String Type) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            Date SaveDate1 = Date.valueOf(SaveDate);
   
            Calendar__c record = new Calendar__c();
                
            record.SaveDate__c = SaveDate1;
            record.Title__c = title;
            record.Customer__c = UserId;
            record.Type__c=Type;
            Insert record;
            
            response.put('Type', record.Type__c);
            response.put('UserId', record.Customer__c);
            response.put('title', record.Title__c);
            response.put('SaveDate', record.SaveDate__c);
            response.put('CalendarId', record.Id);
            response.put('message', 'Your Data is Successfully Saved');
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