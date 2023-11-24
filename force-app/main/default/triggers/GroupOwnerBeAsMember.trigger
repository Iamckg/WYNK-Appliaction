trigger GroupOwnerBeAsMember on Group__c (After insert) {
    List<Group_Member__c> groupMembersToInsert = new List<Group_Member__c>();

    for (Group__c gp : Trigger.New) {   
        Customer__c cust = [SELECT Id, Name, Last_Name__c, Phone__c FROM Customer__c  WHERE Id =:gp.Customer__c];

            Group_Member__c gm = new Group_Member__c();
            gm.Group__c = gp.Id;
            gm.Name = cust.Name;
            gm.MemberId__c = cust.Id;
            gm.LastName__c = cust.Last_Name__c;
            gm.Role__c = 'Admin';
            gm.Phone__c = cust.Phone__c;
            gm.IsJoined__c = true; 
            gm.Pending__c = false;
            gm.isTentative__c = false;
            Insert Gm;

    }
}