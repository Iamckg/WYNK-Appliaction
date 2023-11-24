@RestResource(urlMapping='/CalendardateuserApi/*')
global class Calendar_date_user_Api {
    @HttpPost
    global static void getHomeList(String UserId, String Startdate , String LabelId) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            Date StartDate1 = Date.valueOf(Startdate);
            // Create a list to store filtered data
            List<Map<String, Object>> homeList = new List<Map<String, Object>>();
            List<Map<String, Object>> labels = new List<Map<String, Object>>();
            List<Friend__c> friendList;
            List<String> CalendarCustomerIds = New List<String>();
            if (String.isNotBlank(LabelId)) {
                // When LabelId is not null, filter by LabelId
                friendList = [SELECT Id, Name, FirstName__c, Last_Name__c, Phone__c, Label__r.Name,Label__r.Colour__c, Customer__c ,ImageUrl__c,CountyFlag__c FROM Friend__c WHERE Customer__c = :UserId And Label__c = :LabelId];
            } else {
                // When LabelId is null, fetch all records for the UserId
               friendList = [SELECT Id, Name, FirstName__c, Last_Name__c, Phone__c, Label__r.Name,Label__r.Colour__c, Customer__c ,ImageUrl__c,CountyFlag__c FROM Friend__c WHERE Customer__c = :UserId];
            }

            for (Friend__c friend : friendList) {
                Customer__c cust = [Select Id ,ImageUrl__c From Customer__c Where Id =:friend.Name ];
                Map<String, Object> customerData = new Map<String, Object>();
                customerData.put('Colour', friend.Label__r.Colour__c);
                customerData.put('Label', friend.Label__r.Name);
                customerData.put('CountyFlag', friend.CountyFlag__c);
                customerData.put('ImageUrl', cust.ImageUrl__c);
                customerData.put('LastName', friend.Last_Name__c);
                customerData.put('FirstName', friend.FirstName__c);
                customerData.put('AccountId', friend.Name);

                // Query Calendar__c records for each friend
                List<Calendar__c> calendarList = [SELECT Id, Start_Date__c, isTentative__c, Type__c, SaveDate__c, Title__c, Customer__r.Id, Moving_Date__c FROM Calendar__c
                    WHERE Customer__c = :friend.Name AND Start_Date__c <= :StartDate1 AND Moving_Date__c >= :StartDate1];
              
                List<Map<String, Object>> friendCalendars = new List<Map<String, Object>>();
                for (Calendar__c cal : calendarList) {
                    Map<String, Object> calendarData = new Map<String, Object>();
                    calendarData.put('Type', cal.Type__c);
                    calendarData.put('Tentative', cal.isTentative__c);
                    calendarData.put('MovingDate', cal.Moving_Date__c);
                    calendarData.put('Title', cal.Title__c);
                    calendarData.put('SaveDate', cal.SaveDate__c);
                    calendarData.put('StartDate', cal.Start_Date__c);
                    calendarData.put('CalendarId', cal.Id);
                    calendarData.put('UserId', cal.Customer__r.Id);
                    friendCalendars.add(calendarData);
                    CalendarCustomerIds.add(cal.Customer__r.Id);
                }

                customerData.put('Calendars', friendCalendars);
                homeList.add(customerData);
            }

            // Query the labels associated with the given UserId
            List<Label__c> labelList = [SELECT Id, Name FROM Label__c WHERE Customer__c = :UserId];
           
            for (Label__c labelRecord : labelList) {
                // Query the total count of Friend records for the current label
                Integer friendCount = [SELECT COUNT() FROM Friend__c WHERE Label__c = :labelRecord.Id AND Customer__c = :UserId];
                Map<String, Object> labelData = new Map<String, Object>();
                labelData.put('FriendCount', friendCount); // Include the friend count in the response
                labelData.put('Name', labelRecord.Name);
                labelData.put('AccountId', labelRecord.Id);
                labels.add(labelData);
            }

            response.put('HomeList', homeList);
            response.put('Labels', labels);
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