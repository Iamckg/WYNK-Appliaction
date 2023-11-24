@RestResource(urlMapping='/CalendarUserListByLabel/*')
global class User_By_label {
    @HttpPost
    global static void getLabelList(String UserId, String LabelId) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            // Create a list to store filtered customer data
            List<Map<String, Object>> friendsList = new List<Map<String, Object>>();

            // Query Friend__c records based on UserId
            List<Friend__c> friendRecords;

            if (String.isNotBlank(LabelId)) {
                // When LabelId is not null, filter by LabelId
                friendRecords = [SELECT Id, Name,FirstName__c,Last_Name__c, Label__c,ImageUrl__c,CountyFlag__c,Label__r.Name, Customer__c FROM Friend__c WHERE Customer__c = :UserId AND Label__c = :LabelId];
            } else {
                // When LabelId is null, fetch all records for the UserId
                friendRecords = [SELECT Id, Name,FirstName__c,Last_Name__c, Label__c,ImageUrl__c,CountyFlag__c, Label__r.Name , Customer__c FROM Friend__c WHERE Customer__c = :UserId];
            }

            // Iterate through Friend__c records
            Map<String, Object> friendData = new Map<String, Object>();
            for (Friend__c friend : friendRecords) {     
                    friendData.put('Label', friend.Label__r.Name);
                    friendData.put('LastName', friend.Last_Name__c);
                    friendData.put('CountyFlag', friend.CountyFlag__c);
                    friendData.put('ImageUrl', friend.ImageUrl__c);
                    friendData.put('FirstName', friend.FirstName__c);
                    friendData.put('AccountId', friend.Name);
                    friendsList.add(friendData);
                }
            
            // Add the list of filtered customer data to the response
            response.put('FriendsList', friendsList);
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