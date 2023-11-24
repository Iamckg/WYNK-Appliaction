@RestResource(urlMapping='/MyFriendCalendarDetails/*')
global class MyFriend_CalendarDetails_Api {
    @HttpPost
    global static void getHomeList(String FriendUserId, String UserId) {
        Map<String, Object> response = new Map<String, Object>();
       
        try {
            // Create a list to store filtered data
            List<Map<String, Object>> homeList = new List<Map<String, Object>>();
            
            // Query Calendar__c records
            List<Calendar__c> calendarList = [SELECT Id, Start_Date__c, isTentative__c, Type__c, SaveDate__c, Title__c, Customer__r.Id, Moving_Date__c FROM Calendar__c  WHERE Customer__c = :FriendUserId ];
            for(Calendar__c cal : calendarList) {
                Map<String, Object> calendarData = new Map<String, Object>();
                calendarData.put('Type', cal.Type__c);
                calendarData.put('tentative', cal.isTentative__c);
                calendarData.put('MovingDate', cal.Moving_Date__c);
                calendarData.put('Title', cal.Title__c);
                calendarData.put('SaveDate', cal.SaveDate__c);
                calendarData.put('StartDate', cal.Start_Date__c);
                calendarData.put('calendarId', cal.Id);
                calendarData.put('UserId', cal.Customer__r.Id);
               homeList.add(calendarData) ;
            }

            response.put('CalendarDetails', homeList);
            Customer__c customer = [select Id,name , Last_Name__c, Country__c , State__c , City__c,ImageUrl__c,CountyFlag__c From Customer__c Where Id =:FriendUserId];
            
            response.put('CountyFlag', customer.CountyFlag__c);
            response.put('ImageUrl', customer.ImageUrl__c);
            response.put('city', customer.City__c);
            response.put('state',customer.State__c);
            response.put('Country', customer.Country__c);
            response.put('LastName', customer.Last_Name__c);
            response.put('FirstName' ,customer.Name);
            response.put('FriendUserId', customer.Id);
            Friend__c fr = [Select Id, Name , Label__r.Name , Customer__c From Friend__c Where Name = :FriendUserId AND Customer__c =:UserId LIMIT 1];
            response.put('Label' , fr.Label__r.Name);
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