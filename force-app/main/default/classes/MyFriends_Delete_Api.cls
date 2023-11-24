@RestResource(urlMapping='/MyFriendDelete/*')
global class MyFriends_Delete_Api {
    @HttpPost
    global static void MyfriendList(String MemberId , String UserId) {
        Map<String, Object> response = new Map<String, Object>();

        try { 
            // Query the Friend__c record
            Friend__c friend = [SELECT Id, Name, Customer__c FROM Friend__c WHERE Name = :MemberId AND Customer__c =:UserId LIMIT 1];
            Friend__c friend1 = [SELECT Id, Name, Customer__c FROM Friend__c WHERE Name = :UserId AND Customer__c =:MemberId LIMIT 1];
            if (friend != null && friend1 !=null) {
                // Delete the friend record
                Delete friend;
                Delete friend1;
                response.put('message', 'Your friend is successfully deleted.');
                response.put('Status', 'Success');
            } else {
                response.put('message', 'Friend not found.');
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