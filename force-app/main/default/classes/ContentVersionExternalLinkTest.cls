@isTest
public class ContentVersionExternalLinkTest {

    @isTest
    public static void testTriggerLogic() {
        // Insert test data
        ContentVersion testContentVersion = new ContentVersion(
            VersionData = Blob.valueOf('Test Data'),
            Title = 'Test Content',
            PathOnClient = 'test.txt'
        );
       

        // Call the trigger explicitly
        Test.startTest();
        insert testContentVersion;
        Test.stopTest();

        // Query the database to check if ContentDistribution was inserted
        List<ContentDistribution> distributions = [SELECT Id FROM ContentDistribution WHERE ContentVersionId = :testContentVersion.Id];
        
        // Assert that ContentDistribution was inserted
        System.assertEquals(1, distributions.size(), 'ContentDistribution record should be inserted');

        // You can add more assertions based on your specific requirements
        // For example, you might want to verify the PreferencesNotifyOnVisit, PreferencesAllowViewInBrowser, etc.
        // System.assertEquals(expectedValue, actualValue, 'Error message if the assertion fails');
    }
}