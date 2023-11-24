@RestResource(urlMapping='/FriendRequestAcceptDeclined/*')
global class FriendRequestAcceptDeclined_Api {
    @HttpPost
    global static void AcceptAndDeclineRequest(String SendUserId, String AcceptUserId, String NotificationId, String Type) {
        Map<String, Object> response = new Map<String, Object>();
        List<String> NotificationIds = New List<String>();
        try {
            if (Type.equalsIgnoreCase('Accept')) {
                // Accept the friend request
                
                            Customer__c Acceptcustomer = [SELECT Id, Name,Last_Name__c ,Phone__c,Date_of_Birth__c,ImageUrl__c,CountyFlag__c FROM Customer__c WHERE Id = :AcceptUserId LIMIT 1];
                            Customer__c Sendercustomer = [SELECT Id, Name,Last_Name__c ,Phone__c , Date_of_Birth__c,ImageUrl__c,CountyFlag__c FROM Customer__c WHERE Id = :SendUserId LIMIT 1];
                
                            Friend__c friend1 = new Friend__c();
                            friend1.Name = Acceptcustomer.Id;
                            friend1.FirstName__c = Acceptcustomer.Name;
                            friend1.Last_Name__c = Acceptcustomer.Last_Name__c;
                            friend1.Phone__c = Acceptcustomer.Phone__c;
                            friend1.ImageUrl__c = Acceptcustomer.ImageUrl__c;
                            friend1.CountyFlag__c = Acceptcustomer.CountyFlag__c;
                            friend1.DOB__c = Acceptcustomer.Date_of_Birth__c;
                            friend1.Customer__c = SendUserId;
                            Insert friend1;
                
                            Friend__c friend2 = new Friend__c();
                            friend2.Name = Sendercustomer.Id;
                            friend2.FirstName__c = Sendercustomer.Name;
                            friend2.Last_Name__c = Sendercustomer.Last_Name__c;
                            friend2.Phone__c = Sendercustomer.Phone__c;
                            friend2.ImageUrl__c = Sendercustomer.ImageUrl__c;
                            friend2.CountyFlag__c = Sendercustomer.CountyFlag__c;
                            friend2.DOB__c = Sendercustomer.Date_of_Birth__c;
                            friend2.Customer__c = AcceptUserId;
                            Insert friend2;
                       
                            User_Notification__c notificat = [SELECT Id FROM User_Notification__c WHERE Id = :NotificationId LIMIT 1];
                            Delete notificat;
                    
                            // Notify the member that the friend request is accepted
                            // Accepter notification                    
                            User_Notification__c userNotification = new User_Notification__c();
                            userNotification.Customer__c = AcceptUserId;
                            userNotification.Name = 'Friend Request Accept';
                            userNotification.Message__c = 'You and ' + Sendercustomer.Name + ' are now friends';
                            Insert userNotification;
                            NotificationIds.add(userNotification.Id);
                            //Sender Notification 
               
                            User_Notification__c userNotifications = new User_Notification__c();
                            userNotifications.Customer__c = SendUserId;
                            userNotifications.Name = 'Friend Request Accept';
                            userNotifications.Message__c = 'You and ' + Acceptcustomer.Name + ' are now friends';
                            Insert userNotifications;
                            NotificationIds.add(userNotifications.Id);
                
                            response.put('message', 'You have accepted the friend request.');
                            response.put('Status', 'Success');
                            response.put('NotificationIds', NotificationIds);
                
                  } else if (Type.equalsIgnoreCase('Decline')) {
                    User_Notification__c notificationToDelete = [SELECT Id FROM User_Notification__c WHERE Id = :NotificationId LIMIT 1];
                    Delete notificationToDelete;
                    response.put('message', 'You have declined the friend request.');
                    response.put('Status', 'Success');
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