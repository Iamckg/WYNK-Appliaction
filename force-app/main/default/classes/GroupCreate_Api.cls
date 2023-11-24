@RestResource(urlMapping='/Group/*')
global class GroupCreate_Api {
    @HttpPost
    global static void CreateGroup(String UserId, String title, String GroupDate, String Description, String ImageUrl) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            
            Date groupDate1 = String.isNotBlank(GroupDate) ? Date.valueOf(GroupDate) : null ;
            Group__c gp = new Group__c();
            gp.Name = title;
            gp.Customer__c = UserId;
            gp.Description__c = String.isNotBlank(Description) ? Description : '';
            gp.Date__c = groupDate1;
            gp.ImageUrl__c=ImageUrl;
            gp.ID__c = UserId;
            insert gp;
            
            response.put('ImageUrl', gp.ImageUrl__c);
            response.put('Description', gp.Description__c);
            response.put('GroupDate', gp.Date__c);
            response.put('Name', gp.Name);
            response.put('AccountId', gp.Id);
            response.put('message', 'Your Group is Successfully Created.');
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