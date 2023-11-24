@RestResource(urlMapping='/Banners/*')
global class BannerList_Api {
    @HttpGet
    global static void getBannerList() {
        Map<String, Object> response = new Map<String, Object>();

        try {
            List<Banner__c> records = [SELECT Id, Name, Status__c, (SELECT ContentDocumentId FROM ContentDocumentLinks) FROM Banner__c WHERE Status__c = 'Active'];

            List<Map<String, Object>> bannerList = new List<Map<String, Object>>();

            for (Banner__c record : records) {
                Map<String, Object> bannerData = new Map<String, Object>();

                // Check if the banner has associated ContentDocumentLinks
                if (!record.ContentDocumentLinks.isEmpty()) {
                    // Retrieve the related ContentDocumentId from the first record
                    Id contentDocumentId = record.ContentDocumentLinks[0].ContentDocumentId;

                    // Query the ContentVersion record to get the image data
                    ContentVersion contentVersion = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId LIMIT 1];

                    if (contentVersion != null && contentVersion.VersionData != null) {
                        // Encode the image data as base64
                        String base64Image = EncodingUtil.base64Encode(contentVersion.VersionData);

                        bannerData.put('base64Image', base64Image);
                    }
                }

                bannerData.put('Name', record.Name);
                bannerData.put('BannerId', record.Id);
                bannerList.add(bannerData);
            }

            response.put('BannerList', bannerList);
            response.put('Status', 'Success');
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