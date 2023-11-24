@RestResource(urlMapping='/AvailableFriendsGroupDateListApi/*')
global class Available_Friends_Group_Date_List_Api {
    @HttpPost
    global static void MyfriendList(String UserId, String GroupDate) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            Date GroupDate1 = Date.valueOf(GroupDate);
            List<Map<String, Object>> AvailableFriends = new List<Map<String, Object>>();
            List<Map<String, Object>> UnAvailableFriends = new List<Map<String, Object>>();
            Set<Id> uniqueUnAvailableCustomerIds = new Set<Id>();
            Set<Id> uniqueAvailableCustomerIds = new Set<Id>();

            // Query Friend__c records for the specified user
            List<Friend__c> friendList = [SELECT Id, Name, Customer__c FROM Friend__c WHERE Customer__c = :UserId];

            for (Friend__c friend : friendList) {
                List<Calendar__c> calendarlist = [SELECT Id, Name, Start_Date__c, Moving_Date__c, Location__c, Customer__r.Id
                                                 FROM Calendar__c WHERE Customer__r.Id = :friend.Name];

                for (Calendar__c cal : calendarlist) {
                    if (GroupDate1 >= cal.Start_Date__c && GroupDate1 <= cal.Moving_Date__c) {
                        // Query Friend__c records for the same customer and add them to a list
                        List<Friend__c> friendRecords = [SELECT Id, Name, FirstName__c, Last_Name__c,ImageUrl__c,CountyFlag__c, Phone__c, Label__r.Name FROM Friend__c WHERE Name = :cal.Customer__c];
                        for (Friend__c fri : friendRecords) {
                            Map<String, Object> data1 = new Map<String, Object>();
                            if (!uniqueAvailableCustomerIds.contains(fri.Name)) {
                               
                                data1.put('CountyFlag', fri.CountyFlag__c);
                                data1.put('ImageUrl', fri.ImageUrl__c);
                                data1.put('Label', fri.Label__r.Name);
                                data1.put('Phone', fri.Phone__c);
                                data1.put('LastName', fri.Last_Name__c);
                                data1.put('FirstName', fri.FirstName__c);
                                data1.put('AccountId', fri.Name);
                                uniqueUnAvailableCustomerIds.Add(fri.Name);
                                AvailableFriends.add(data1); // Add data to the AvailableFriends list
                                uniqueAvailableCustomerIds.add(fri.Name); // Track the added friend
                            }
                        }
                    }
                }
            }

            List<Friend__c> friendList1 = [SELECT Id, Name, Customer__c, FirstName__c, Last_Name__c,ImageUrl__c,CountyFlag__c, Phone__c, Label__r.Name FROM Friend__c WHERE Customer__c = :UserId];
            for (Friend__c friend1 : friendList1) {
                if (!uniqueUnAvailableCustomerIds.contains(friend1.Name)) {
                    Map<String, Object> data2 = new Map<String, Object>();
                    
                    data2.put('CountyFlag', friend1.CountyFlag__c);
                    data2.put('ImageUrl', friend1.ImageUrl__c);
                    data2.put('Label', friend1.Label__r.Name);
                    data2.put('Phone', friend1.Phone__c);
                    data2.put('LastName', friend1.Last_Name__c);
                    data2.put('FirstName', friend1.FirstName__c);
                    data2.put('AccountId', friend1.Name);
                    UnAvailableFriends.add(data2); // Add data to the UnAvailableFriends list
                }
            }

            // Add the lists to the response
            response.put('UnAvailableFriends', UnAvailableFriends);
            response.put('AvailableFriends', AvailableFriends);
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