@RestResource(urlmapping='/LabelDelete/*')
Global class LabelEdit_Api {
    @HttpPost
    global static void editLabel(String AccountId) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
             // Check if a Label__c record with the given Id exists
             Label__c existingRecords = [SELECT Id, Name FROM Label__c WHERE Id = :AccountId ];
             Delete existingRecords;
          
             response.put('message', 'Label has been Deleted successfully');
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