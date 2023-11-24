@RestResource(urlMapping='/MyFriendDOB/*')
global class MyFriends_DOB_Api {
    @HttpPost
    global static void MyfriendList(String UserId) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            List<Map<String, Object>> MyfriendsList = new List<Map<String, Object>>();

            // Query Friend__c records for the specified user
            List<Friend__c> friendList = [SELECT Id, Name, DOB__c, FirstName__c, Last_Name__c, Phone__c, Label__r.Name, Customer__c,ImageUrl__c,CountyFlag__c FROM Friend__c WHERE Customer__c = :UserId];

            List<Id> friendNames = new List<Id>();
            
            for (Friend__c friend : friendList) {
                Map<String, Object> friendData = new Map<String, Object>();
                friendData.put('Label', friend.Label__r.Name);
                friendData.put('CountyFlag', friend.CountyFlag__c);
                friendData.put('ImageUrl', friend.ImageUrl__c);
                friendData.put('Phone', friend.Phone__c);
                friendData.put('DOB', friend.DOB__c);
                friendData.put('LastName', friend.Last_Name__c);
                friendData.put('FirstName', friend.FirstName__c);
                friendData.put('AccountId', friend.Name);
                friendNames.add(friend.Id);

                MyfriendsList.add(friendData);
            }

            Customer__c cust = [SELECT Id, Date_of_Birth__c FROM Customer__c WHERE Id = :UserId];
            response.put('MyDOB', cust.Date_of_Birth__c);
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