@RestResource(urlMapping='/MyFriendSearchKeyword/*')
global class MyFriendSearch_Keyword_Api {
    @HttpPost
    global static void MyfriendList(String UserId, String Keyword) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            List<Map<String, Object>> MyfriendsList = new List<Map<String, Object>>();
            String likeKeyword = '%' + Keyword + '%';

            // Query Friend__c records for the specified user with the provided keyword filter
            List<Friend__c> friendList = [SELECT Id, Name, FirstName__c, Last_Name__c, Phone__c, Label__r.Name, Customer__c,ImageUrl__c,CountyFlag__c
                                          FROM Friend__c WHERE Customer__c = :UserId
                                          AND (FirstName__c LIKE :likeKeyword OR Last_Name__c LIKE :likeKeyword OR Phone__c LIKE :likeKeyword)];

            for (Friend__c friend : friendList) {
                Map<String, Object> friendData = new Map<String, Object>(); 
                friendData.put('Label', friend.Label__r.Name);
                friendData.put('CountyFlag', friend.CountyFlag__c);
                friendData.put('ImageUrl', friend.ImageUrl__c);
                friendData.put('Phone', friend.Phone__c);
                friendData.put('LastName', friend.Last_Name__c);
                friendData.put('FirstName', friend.FirstName__c);
                friendData.put('AccountId', friend.Name);
                MyfriendsList.add(friendData);
            }
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