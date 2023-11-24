public class GroupDetailsController {
    public String GroupName { get; set; }
    public Date GroupDate { get; set; }
    public String Description { get; set; }
    public String Base64Image { get; set; }
    public Integer TotalMembers { get; set; }
    public Integer TotalAdmin { get; set; }
    public Integer TotalTenative { get; set; }
    public Integer TotalJoined { get; set; }
    public Integer TotalDeclined { get; set; }
    public List<Map<String, Object>> MembersDetails { get; set; }

    public GroupDetailsController() {
      String GroupId = ApexPages.currentPage().getParameters().get('id'); 
     //   String GroupId = ApexPages.currentPage().getParameters().get('id');
        Group__c gp = [SELECT Id, Name, Date__c, Description__c, Total_Members__c,  (SELECT ContentDocumentId FROM ContentDocumentLinks) 
                       FROM Group__c WHERE Id = :GroupId];

        if (gp != null) {
            GroupName = gp.Name;
            GroupDate = gp.Date__c;
            Description = gp.Description__c;
            TotalMembers = Integer.valueOf(gp.Total_Members__c);

         
            List<Group_Member__c> MembersList = [SELECT Name, LastName__c, Role__c, IsJoined__c, IsTentative__c, MemberId__c, Pending__c, Phone__c, Declined__c,Group__c
                                                 FROM Group_Member__c WHERE Group__c =:GroupId];

            MembersDetails = new List<Map<String, Object>>();
            TotalAdmin = 0;
            TotalTenative = 0;
            TotalJoined = 0;
            TotalDeclined = 0;

            for (Group_Member__c mem : MembersList) {
                Map<String, Object> MemberData = new Map<String, Object>();
                MemberData.put('FirstName', mem.Name);
                MemberData.put('LastName', mem.LastName__c);
                MemberData.put('Role', mem.Role__c);
                MemberData.put('IsJoined', mem.IsJoined__c);
                MemberData.put('IsTentative', mem.IsTentative__c);
                MemberData.put('Pending', mem.Pending__c);
                MemberData.put('Declined', mem.Declined__c);
                MemberData.put('Phone', mem.Phone__c);
                MembersDetails.add(MemberData);

                if (mem.Role__c != null && mem.Role__c.equals('Admin')) {
                    TotalAdmin++;
                }

                if (mem.IsTentative__c) {
                    TotalTenative++;
                } else if (mem.IsJoined__c) {
                    TotalJoined++;
                } else if (mem.Declined__c) {
                    TotalDeclined++;
                }
            }
        }
    }
}