@RestResource(urlMapping='/pingUnping/*')
global class PingAndUnping_Api {
    @HttpPost
    global static void pinguping(String UserId, String FriendUserId, Boolean IsPing) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            // Query the Friend's name
            Customer__c customer = [SELECT Id, Name FROM Customer__c WHERE Id = :UserId];

            // Query User_Notification__c record for the FriendUserId

            if (IsPing == true) {
                // Create a new User_Notification__c record
                User_Notification__c userNotifications = new User_Notification__c();
                userNotifications.Customer__c = FriendUserId;
                userNotifications.Name = 'Pinged Notification';
                userNotifications.IsPing__c = IsPing;
                userNotifications.Message__c = 'You have been pinged by your friend ' + customer.Name;
                insert userNotifications;
                response.put('NotificationIds', userNotifications.Id);
                response.put('IsPing', 'True');
                response.put('message', 'You have pinged your friend.');
            } else {
 
                response.put('IsPing', 'false');
                response.put('message',  'You have unpinged your friend.');
            }

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