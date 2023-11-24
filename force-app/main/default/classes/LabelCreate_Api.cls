@RestResource(urlmapping='/LabelCreate/*')
Global class LabelCreate_Api {
    @HttpPost
    global static void createLabel(String label , String UserId, String Colour) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            // Query for an existing label with the provided name
            List<Label__c> existingLabel = [SELECT Id, Name, Customer__c FROM Label__c WHERE Name = :label AND Customer__c = :UserId LIMIT 1];
          
            if (existingLabel.isEmpty()) {
                // If the label doesn't exist, create a new one
                Label__c newLabel = new Label__c();
                newLabel.Name = label;
                newLabel.Colour__c=Colour;
                newLabel.Customer__c = UserId;
                insert newLabel;
                
                response.put('Name', newLabel.Name);
                response.put('AccountId', newLabel.Id);
                response.put('message', 'Label has been created successfully');
                response.put('Status', 'Success');
            } else {
                // If a label with the same name exists, set the response accordingly
                response.put('Name', label);
                response.put('message', 'Label Name already exists !!');
                response.put('Status', 'Failed');
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