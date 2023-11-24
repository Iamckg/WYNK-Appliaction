@RestResource(urlMapping='/MyFriendList/*')
global class MyFriendList_Api {
    @HttpPost
    global static void MyfriendList(String UserId, String LabelId) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            List<Map<String, Object>> MyfriendsList = new List<Map<String, Object>>();
            List<Friend__c> friendList;
            // Query Friend__c records for the specified user
           if (String.isNotBlank(LabelId)) {
                // When LabelId is not null, filter by LabelId
                friendList = [SELECT Id, Name, FirstName__c, Last_Name__c, Phone__c,ImageUrl__c,CountyFlag__c, Label__r.Name, Label__r.Colour__c, Customer__c  FROM Friend__c WHERE Customer__c = :UserId And Label__c = :LabelId];
            } else {
                // When LabelId is null, fetch all records for the UserId
               friendList = [SELECT Id, Name, FirstName__c, Last_Name__c, Phone__c ,ImageUrl__c,CountyFlag__c,Label__r.Name,Label__r.Colour__c, Customer__c  FROM Friend__c WHERE Customer__c = :UserId];
            }
            for (Friend__c friend : friendList) {
                    Customer__c cust = [Select Id ,ImageUrl__c From Customer__c Where Id =:friend.Name ];
                    Map<String, Object> friendData = new Map<String, Object>(); 
                    friendData.put('Colour', friend.Label__r.Colour__c);
                    friendData.put('Label', friend.Label__r.Name);
                    friendData.put('Phone', friend.Phone__c);
                    
                    friendData.put('ImageUrl', cust.ImageUrl__c);
                    friendData.put('CountyFlag', friend.CountyFlag__c);
                    friendData.put('LastName', friend.Last_Name__c);
                    friendData.put('FirstName', friend.FirstName__c);
                    friendData.put('AccountId', friend.Name);
                    MyfriendsList.add(friendData);
                }
                // Add the list of filtered friend data to the response
                response.put('FriendsList', MyfriendsList);
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