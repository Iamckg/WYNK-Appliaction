@RestResource(urlmapping='/AddNewLabel/*')
global class AddNewLabel {
    @HttpPost
    global static void UpdateLabel(String UserId, String  FriendUserId, String labelId) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
                // Update the Label__c field on related Friend__c records
                Friend__c friendsToUpdate = [SELECT Id, Name ,Label__c  FROM Friend__c WHERE Customer__c = :UserId AND Name = :FriendUserId];
                friendsToUpdate.Label__c = labelId;
                update friendsToUpdate;
                
                response.put('message', 'Your Label is Successfully Added');
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