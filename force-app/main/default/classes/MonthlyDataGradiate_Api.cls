@RestResource(urlMapping='/MonthlyDataGradiate/*')
global class MonthlyDataGradiate_Api {
    @HttpPost
    global static void getHomeList(String UserId, List<String> stringDates) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            List<Date> dateList = new List<Date>();
            for (String dateString : stringDates) {
                Date dateValue = Date.valueOf(dateString);
                dateList.add(dateValue);
            }

            List<Map<String, Object>> dateDataList = new List<Map<String, Object>>();

            // Query the list of friends
            List<Friend__c> friendList = [SELECT Id, Name FROM Friend__c WHERE Customer__c = :UserId];
            Set<String> friendListNames = new Set<String>();
            for (Friend__c friend : friendList) {
                friendListNames.add(friend.Name);
            }

            // Query Calendar__c records for all friends for all dates in one query
            List<Calendar__c> calendarList = [
                SELECT Id, Start_Date__c, Moving_Date__c, Customer__c
                FROM Calendar__c
                WHERE Customer__c IN :friendListNames
                AND Start_Date__c <= :dateList
                AND Moving_Date__c >= :dateList
            ];

            for (Date d : dateList) {
                Integer totalCalendarCount = 0;
                for (Friend__c fri : friendList) {
                    for (Calendar__c cal : calendarList) {
                        if (cal.Customer__c == fri.Name && cal.Start_Date__c <= d && cal.Moving_Date__c >= d) {
                            totalCalendarCount++;
                        }
                    }
                }
               
                // Calculate other data as needed
                Map<String, Object> dateData = new Map<String, Object>();
               
                dateData.put('Gradiate', calculatePercentage(totalCalendarCount, friendList.size()));
                dateData.put('totalFriendCount', friendList.size());
                dateData.put('TotalCalendarCount', totalCalendarCount);
                dateData.put('StartDate', d);
                dateDataList.add(dateData);
            }

            response.put('CalendarDetails', dateDataList);
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

    // Helper method to calculate percentage
    private static Decimal calculatePercentage(Integer part, Integer total) {
        return total > 0 ? (Decimal)part / total * 100 : 0.0;
    }
}