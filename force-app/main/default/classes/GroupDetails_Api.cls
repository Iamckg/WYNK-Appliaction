@RestResource(urlMapping='/GroupDetailsApi/*')
global class GroupDetails_Api {
    @HttpPost
    global static void getGroupDetail(String GroupId) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            Group__c gp = [SELECT Id,Name,Customer__r.Id,Customer__r.Name,Customer__r.Last_Name__c,Date__c,ImageUrl__c,Description__c,Total_Members__c FROM Group__c WHERE Id = :GroupId LIMIT 1];

            if (gp != null) {
                response.put('TotalMembers', gp.Total_Members__c);
                response.put('TotalDeclined', 0);
                response.put('TotalAttend', 0);
                response.put('TotalTenative', 0);
                response.put('TotalJoined', 0);
                response.put('TotalAdmin', 0);
                response.put('ImageUrl', gp.ImageUrl__c);
                response.put('Description', gp.Description__c);
                response.put('GroupDate', gp.Date__c);
                response.put('GroupName', gp.Name);
                response.put('GroupId', gp.Id);
     

                List<Map<String, Object>> MembersDetails = new List<Map<String, Object>>();

                List<Group_Member__c> MembersList = [SELECT Id, Name, LastName__c, IsJoined__c, Attend__c, IsTentative__c, MemberId__c, Pending__c, Phone__c, Declined__c, Role__c, Group__r.Id 
                                                     FROM Group_Member__c WHERE Group__r.Id = :GroupId ORDER BY Role__c ASC];

                for (Group_Member__c mem : MembersList) {
                    
                    Customer__c cust = [Select Id ,ImageUrl__c From Customer__c Where Id =:mem.MemberId__c ];
                    Map<String, Object> MemberData = new Map<String, Object>();

                    MemberData.put('IsPending', mem.Pending__c);
                    MemberData.put('IsDeclined', mem.Declined__c);
                    MemberData.put('IsJoined', mem.IsJoined__c);
                    MemberData.put('IsAttend', mem.Attend__c);
                    MemberData.put('IsTentative', mem.IsTentative__c);
                    MemberData.put('Role', mem.Role__c);
                    MemberData.put('ImageUrl', cust.ImageUrl__c);
                    MemberData.put('LastName', mem.LastName__c);
                    MemberData.put('FirstName', mem.Name);
                    MemberData.put('MemberId', mem.MemberId__c);

                    MembersDetails.add(MemberData);

                    if (mem.Role__c != null && mem.Role__c.equals('Admin')) {
                        response.put('TotalAdmin', (Integer)response.get('TotalAdmin') + 1);
                    }
                    
                    if (mem.Attend__c) {
                        response.put('TotalAttend', (Integer)response.get('TotalAttend') + 1); 
                    }
                   if (mem.IsTentative__c) {
                        response.put('TotalTenative', (Integer)response.get('TotalTenative') + 1);
                   }
                    if (mem.IsJoined__c) {
                        response.put('TotalJoined', (Integer)response.get('TotalJoined') + 1);
                    } 
                     if (mem.Declined__c) {
                        response.put('TotalDeclined', (Integer)response.get('TotalDeclined') + 1);
                    }
                }

                response.put('MembersDetails', MembersDetails);
                response.put('Status', 'Success');
            } else {
                response.put('Status', 'Failed');
                response.put('Message', 'Group not found');
            }
        } catch (Exception ex) {
            response.put('Status', 'Failed');
            response.put('Message', ex.getMessage());
        }

        String jsonResponse = JSON.serialize(response);

        // Return the JSON response
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonResponse);
    }
}