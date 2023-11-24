@RestResource(urlMapping='/AddGroupMembers/*')
global with sharing class AddMembers_Api {
    @HttpPost
    global static void AddMembers(String GroupId, List<String> MemberIds) {
        Map<String, Object> response = new Map<String, Object>();
        try {
            // Retrieve the group record
            Group__c gp = [SELECT Id FROM Group__c WHERE Id = :GroupId LIMIT 1];
            if (gp != null) {
                List<String> notificationIds = new List<String>();
                List<Customer__c> membersToUpdate = [SELECT Id, Name, Last_Name__c, Phone__c, Device_Token__c FROM Customer__c WHERE Id IN :MemberIds];

                // Create a set to store the existing MemberId__c values for the group
                Set<Id> existingMemberIds = new Set<Id>();

                // Query for existing Group_Member__c records
                List<Group_Member__c> existingGroupMembers = [SELECT MemberId__c FROM Group_Member__c WHERE Group__c = :GroupId];

                // Populate the set with existing MemberId__c values
                for (Group_Member__c existingMember : existingGroupMembers) {
                    existingMemberIds.add(existingMember.MemberId__c);
                }

                Group__c groupRecord = [SELECT Id, Name, Date__c, Customer__c, Customer__r.Name FROM Group__c WHERE Id = :GroupId];
                String FromatDate = groupRecord.Date__c.year()+'-'+groupRecord.Date__c.month()+'-'+groupRecord.Date__c.day();
                List<Group_Member__c> groupMembersToInsert = new List<Group_Member__c>();

                for (Customer__c member : membersToUpdate) {
                    if (!existingMemberIds.contains(member.Id)) {
                        Group_Member__c gm = new Group_Member__c();
                        gm.Group__c = GroupId;
                        gm.Name = member.Name;
                        gm.MemberId__c = member.Id;
                        gm.LastName__c = member.Last_Name__c;
                        gm.Phone__c = member.Phone__c;
                        groupMembersToInsert.add(gm);

                        // Create notification for user
                        User_Notification__c userNotification = new User_Notification__c();
                        userNotification.Customer__c = member.Id;
                        userNotification.Name = 'Group Join Request';
                        userNotification.CustomId__c = GroupId;
                        userNotification.Message__c = groupRecord.Customer__r.Name + ' has invited you to his event ' + groupRecord.Name + ' on the date ' + FromatDate;
                        Insert userNotification;
                        notificationIds.add(userNotification.Id);
                    }
                }

                // Insert only non-duplicate members
                if (!groupMembersToInsert.isEmpty()) {
                    Insert groupMembersToInsert;
                    response.put('notificationIds', notificationIds); // Pass the notification IDs
                    response.put('message', 'Your Group Members are Successfully Added');
                    response.put('Status', 'Success');
                } else {
                    response.put('message', 'No new members were added');
                    response.put('Status', 'Success');
                }
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