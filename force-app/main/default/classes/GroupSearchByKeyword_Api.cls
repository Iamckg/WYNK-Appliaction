@RestResource(urlMapping='/GroupSearchByKeyword/*')
global class GroupSearchByKeyword_Api {
    @HttpPost
    global static void getLabelList(String UserId , String Keyword) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            // Create a list to store group data
            List<Map<String, Object>> GroupsList = new List<Map<String, Object>>();

            // Use binding variables for the query
            String likeKeyword = '%' + Keyword + '%';

            // Query Group_Member__c records to find groups associated with the user
            List<Group_Member__c> GpList = [
                SELECT Id, Name, IsJoined__c, Declined__c, Group__r.Id, Group__r.Name,Group__r.ImageUrl__c, Group__r.Total_Members__c, Group__r.Date__c, Group__r.Description__c, Group__r.Customer__r.Name
                FROM Group_Member__c
                WHERE MemberId__c = :UserId AND Group__r.Name LIKE :likeKeyword AND Declined__c = false];

            for (Group_Member__c gp : GpList) {
                Map<String, Object> groupData = new Map<String, Object>();
                groupData.put('IsDeclined', gp.Declined__c);
                groupData.put('IsJoined', gp.IsJoined__c);
                groupData.put('GroupAdmin', gp.Group__r.Customer__r.Name);
                groupData.put('Description', gp.Group__r.Description__c);
                groupData.put('TotalMembers', gp.Group__r.Total_Members__c);
                groupData.put('ImageUrl', gp.Group__r.ImageUrl__c);
                groupData.put('GroupDate', gp.Group__r.Date__c);
                groupData.put('GroupName', gp.Group__r.Name);
                groupData.put('GroupId', gp.Group__r.Id);

                GroupsList.add(groupData);
            }
  
            // Add the list of filtered group data to the response
            response.put('GroupList', GroupsList);
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