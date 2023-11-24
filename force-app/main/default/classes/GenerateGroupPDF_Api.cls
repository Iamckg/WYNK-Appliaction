@RestResource(urlMapping='/GenerateGroupPDF/*')
global with sharing class GenerateGroupPDF_Api {

    @HttpPost
    global static void generateGroupPDF(String GroupId) {
        Map<String, Object> response = new Map<String, Object>();
        try {      
         PageReference pageRef = Page.GroupDetailsPage; // Replace with the name of your Visualforce page
         pageRef.getParameters().put('id', GroupId); // Pass the GroupId as a parameter

         // Render the page as PDF
         Blob pdfBlob;
         if (!Test.isRunningTest()) {
            pdfBlob = pageRef.getContentAsPDF();
         } else {
             pdfBlob = Blob.valueOf('Test PDF Content');
         }

         // Convert the PDF Blob to Base64
         String base64PDF = EncodingUtil.base64Encode(pdfBlob);
   
         response.put('Status', 'Success');
         response.put('base64PDF', base64PDF);
            
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