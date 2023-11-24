public class NotificationCalloutHandler {
    
    @future(callout=true)
    public static void notifyCustomers(List<Id> customerIds,String message) {
        List<Customer__c> customers = [SELECT Id, Device_Token__c FROM Customer__c WHERE Id IN :customerIds AND Device_Token__c != null];

        if (!customers.isEmpty()) {
            String serverKey = 'AAAAPeLnvKY:APA91bFFcjgAqx1b-UpLP9D4EvfGhEtzYJzkfC5LoBD9wj9NcJD5l_csOxwsispbUMo1BgFhsktjfQxnEoyCiy1gKyVPXF-5ruAPRiuUU6QkLMup1-H0ajUyOwvnW8_nVH3JNzg5bAgh'; 
            String endpoint = 'https://fcm.googleapis.com/fcm/send';

            for (Customer__c cust : customers) {
                String notificationPayload = '{"to":"' + cust.Device_Token__c + '", "notification":{"body":"' + message + '", "title":"Admin notification"} }';

                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(endpoint);
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                request.setHeader('Authorization', 'Key=' + serverKey);
                request.setBody(notificationPayload);

                HttpResponse response = http.send(request);

                // Handle the response here if needed
            }
        }
    }
}