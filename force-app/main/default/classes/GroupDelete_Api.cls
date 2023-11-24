@RestResource(urlMapping='/GroupDelete/*')
global class GroupDelete_Api {
    @HttpPost
    global static void DeleteGroup(String UserId, String GroupId) {
        Map<String, Object> response = new Map<String, Object>();
        try {
            // Query the group to check if it exists and belongs to the user
            Group__c gp = [SELECT Id, Name, Customer__c FROM Group__c WHERE Id = :GroupId AND Customer__c = :UserId LIMIT 1];
             
            if (gp != null) {
                List<Group_Member__c> membersToUpdate = [SELECT Id ,Declined__c FROM Group_Member__c WHERE Group__c = :gp.Id];   
                Delete membersToUpdate;
                delete gp;
        
                response.put('Message', 'Successfully deleted your Group');
                response.put('Status', 'Success');
            } else {
                response.put('Message', 'Group not found or you do not have permission to delete it');
                response.put('Status', 'Failed');
            }
        } catch (Exception ex) {
            response.put('Message', ex.getMessage());
            response.put('Status', 'Failed');
        }
        String jsonResponse = JSON.serialize(response);

        // Return the JSON response
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonResponse);
    }
}