@RestResource(urlMapping='/CalendarWeeklyData/*')
global class Calendar_WeeklyData_Api {
    @HttpPost
    global static void getHomeList(String UserId, List<String> Dates, String LabelId) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            List<Date> weeklyDates = new List<Date>();
            for (String dateStr : Dates) {
                weeklyDates.add(Date.valueOf(dateStr));
            }

            // Create a list to store filtered data
            List<Map<String, Object>> homeList = new List<Map<String, Object>>();
            List<Friend__c> friendList;

            if (String.isNotBlank(LabelId)) {
                // When LabelId is not null, filter by LabelId
                friendList = [SELECT Id, Name, FirstName__c, Last_Name__c, Phone__c, Label__r.Name,Label__r.Colour__c, Customer__c,ImageUrl__c,CountyFlag__c   FROM Friend__c    WHERE Customer__c = :UserId AND Label__c = :LabelId];
            } else {
                // When LabelId is null, fetch all records for the UserId
                friendList = [SELECT Id, Name, FirstName__c, Last_Name__c, Phone__c, Label__r.Name,Label__r.Colour__c, Customer__c,ImageUrl__c,CountyFlag__c FROM Friend__c  WHERE Customer__c = :UserId];
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

                // Query Calendar__c records for each friend within the week range
                List<Calendar__c> calendarList = [SELECT Id, Start_Date__c, isTentative__c, Type__c, SaveDate__c, Title__c, Customer__r.Id, Moving_Date__c  FROM Calendar__c  WHERE Customer__c = :friend.Name   AND (Start_Date__c IN :weeklyDates OR Moving_Date__c IN :weeklyDates)];

                List<Map<String, Object>> friendCalendars = new List<Map<String, Object>>();
                for (Calendar__c cal : calendarList) {
                // Date List Between Start date and moving date    
                List<Date> dateList = new List<Date>();
                Date currentDate = cal.Start_Date__c;

                while (currentDate <= cal.Moving_Date__c) {
                dateList.add(currentDate);
                currentDate = currentDate.addDays(1);
                }
                    Map<String, Object> calendarData = new Map<String, Object>();
                    calendarData.put('dateList', dateList);
                    calendarData.put('MovingDate', cal.Moving_Date__c);                   
                    calendarData.put('StartDate', cal.Start_Date__c);
                    calendarData.put('CalendarId', cal.Id);
                    calendarData.put('UserId', cal.Customer__r.Id);
                    friendCalendars.add(calendarData);
                }

                customerData.put('Calendars', friendCalendars);
                homeList.add(customerData);
            }

            // Query the labels associated with the given UserId
            List<Label__c> labelList = [SELECT Id, Name
                                        FROM Label__c
                                        WHERE Customer__c = :UserId];

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