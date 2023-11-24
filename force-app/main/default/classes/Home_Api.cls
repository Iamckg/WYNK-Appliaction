@RestResource(urlMapping='/Home/*')
global class Home_Api {
    @HttpPost
    global static void getHomeList(String UserId) {
        Map<String, Object> response = new Map<String, Object>();
       
        try {
            // Create a list to store filtered data
            List<Map<String, Object>> homeList = new List<Map<String, Object>>();

            // Query Calendar__c records
            List<Calendar__c> calendarList = [SELECT Id, Start_Date__c, isTentative__c, Type__c, SaveDate__c, Title__c, Customer__r.Id, Moving_Date__c FROM Calendar__c  WHERE Customer__c = :UserId ];
            for(Calendar__c cal : calendarList) {
               
               // Date List Between Start date and moving date    
                List<Date> dateList = new List<Date>();
                Date currentDate = cal.Start_Date__c;

                while (currentDate <= cal.Moving_Date__c) {
                dateList.add(currentDate);
                currentDate = currentDate.addDays(1);
                }
                
                Map<String, Object> calendarData = new Map<String, Object>();
                calendarData.put('dateList', dateList);
                calendarData.put('Type', cal.Type__c);
                calendarData.put('tentative', cal.isTentative__c);
                calendarData.put('MovingDate', cal.Moving_Date__c);
                calendarData.put('Title', cal.Title__c);
                calendarData.put('SaveDate', cal.SaveDate__c);
                calendarData.put('StartDate', cal.Start_Date__c);
                calendarData.put('calendarId', cal.Id);
                calendarData.put('UserId', cal.Customer__r.Id);

                // Query Friend__c records for the customer
                List<Friend__c> friendList = [SELECT Id, Name,FirstName__c, Last_Name__c , DOB__c ,Phone__c ,Label__r.Name FROM Friend__c WHERE Customer__c = :cal.Customer__r.Id];

                // Create a list to store customer data
                List<Map<String, Object>> customerList = new List<Map<String, Object>>();
                for (Friend__c friend : friendList) {
                        Map<String, Object> customerData = new Map<String, Object>();
                        customerData.put('DOB',friend.DOB__c);
                        customerData.put('phone',friend.Phone__c);
                        customerData.put('Label', friend.Label__r.Name);
                        customerData.put('LastName', friend.Last_Name__c);
                        customerData.put('FirstName', friend.FirstName__c);
                        customerData.put('AccountId', friend.Name);
                        customerList.add(customerData);          
                }
                // Add the customer list to calendar data
                calendarData.put('Friends', customerList);
                homeList.add(calendarData);
            }
            
            // Query the labels associated with the given UserId
            List<Label__c> labelList = [SELECT Id, Name, Customer__c FROM Label__c Where Customer__c =:UserId];
            
            // Create a list to store label names
            List<String> labelNames = new List<String>();
            
            for (Label__c label : labelList) {
                labelNames.add(label.Name);
            }
            
            response.put('HomeList', homeList);
            response.put('Labels', labelNames);
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