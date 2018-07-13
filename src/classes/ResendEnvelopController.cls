Public class ResendEnvelopController{
    
    String account;
    String UserName;
    String Password;
    String IntegratorKey;
    String endPointURL;
    String boundary = 'AAA';
    String authorizationHeader;
    String documentPDF;
    String endpoint;
    public String reciName;
    Public String envelopId;
    public Id CurrentRecId;
    public ResendEnvelopController(){
        Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
        
        for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
            
            UserName = credentialIns.name;
            account = credentialIns.account__c;
            Password = credentialIns.Password__c;
            IntegratorKey  = credentialIns.IntegratorKey__c;
            endPointURL = credentialIns.end_Point__c;
        }
        authorizationHeader = '<DocuSignCredentials><Username>'+UserName+'</Username><Password>'+Password+'</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
        endpoint = endPointURL+'/accounts/'+account+'/envelopes';
    }
    public void resendEnvelop(string envelop,string name,string email){
        
        String endpoint = endPointURL+'/accounts/'+account+'/envelopes/'+envelop+'/recipients?resend_envelope=true'; 
        String body =  '{'+
            '  "signers": [{'+
            '      "email": "'+email+'",'+
            '      "name": "'+name+'",'+
            '      "resend_envelope":"true",'+
            '      "recipientId": "1"'+
            '  }]'+
            '}';
        
        String header = '--'+boundary+'\nContent-Type: application/json\nContent-Disposition: form-data';
        String jsonBody = header +'\n\n'+body+'\n\n--'+boundary+'--';
        
        //Callout to Docusign.
        HttpRequest req = new HttpRequest();
        req.setHeader('X-DocuSign-Authentication', authorizationHeader);
        req.setHeader('Accept','application/json');
        req.setHeader('Host','demo.docusign.net');
        req.setHeader('Content-Length','162100');
        req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
        req.setEndpoint(endpoint);
        req.setMethod('PUT'); 
        req.setBody(jsonBody);
        Http http = new Http();
        HTTPResponse res;
        res = http.send(req);
        
        List<dsfs__DocuSign_Recipient_Status__c> dbRecipientList = new List<dsfs__DocuSign_Recipient_Status__c> ();
        for(dsfs__DocuSign_Recipient_Status__c dbRecipnt : [SELECT Id,dsfs__Date_Sent__c,dsfs__Envelope_Id__c FROM dsfs__DocuSign_Recipient_Status__c WHERE dsfs__Envelope_Id__c =: envelop]){
            dsfs__DocuSign_Recipient_Status__c updatedsfsReci  = new dsfs__DocuSign_Recipient_Status__c ();
            updatedsfsReci .Id = dbRecipnt.Id;
            updatedsfsReci.dsfs__Date_Sent__c = system.Today();
            dbRecipientList.add(dbRecipnt);
        }
        
        if(dbRecipientList.size() > 0)
        update dbRecipientList;
    }
    
    
    public Pagereference signNowEnvelop(string envelop,string name,String currCaseId,String pageName){
        PageReference reference;
        Pagereference PDF;
        Id caseId;
        if(pageName == 'WishInformationForm_VF'){
            PDF = Page.SignNowPDF;
        }
        if(pageName == 'WishLiabilityForm_VF'){
            PDF = Page.WishLiabilitySignNow;
            caseId = currCaseId;
            currCaseId =currCaseId+'&option=Three';
        }
        if(pageName == 'WishFormWishGranting_VF'){
            pageName = 'WishGranting_VF';
            PDF = Page.SignNowPDF;
        }
        if(pageName == 'WishLiabilityWishGranting_VF'){
            pageName = 'WishGranting_VF';
            caseId = currCaseId;
            PDF = Page.WishLiabilitySignNow;
        }
        if(currCaseId != currCaseId+'&option=Three'){
        PDF.getParameters().put('Id',currCaseId);
        }
        if(currCaseId != currCaseId+'&option=Three'){
        PDF.getParameters().put('Id',caseId);
        }
        try {
            //If(!Test.isrunningtest())
            documentPDF = EncodingUtil.base64Encode(PDF.getContentAsPDF());
        }
        catch(Exception e){
            e.getMessage();
        }
        endpoint += '/'+envelop+'/views/recipient';
        string endpoint2 = endPointURL+'/accounts/'+account+'/envelopes/'+envelop +'/recipients'; 
        system.debug('@@@ endPoint @@@'+endpoint);
        system.debug('@@endpoint2@@'+endpoint2);
        HttpRequest request = new HttpRequest();
        request.setHeader('X-DocuSign-Authentication', authorizationHeader);
        request.setHeader('Accept','application/json');
        request.setHeader('Host','demo.docusign.net');
        request.setHeader('Content-Length','162100');
        request.setHeader('Content-Type','application/json');
        request.setMethod('POST'); 
        Http httprequest = new Http();
        HTTPResponse response;
        request.setEndpoint(endpoint);
        string jsonPayload;
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        system.debug('@@ wcfUtil.SignNowName1 @@ '+name);
        jsonPayload = '{'+
            '    "userName": "'+name+'",'+
            '    "email": "NotSent@NoEmail.com",'+
            '    "recipientId": "1",'+
            '    "clientUserId": "1",'+
            '    "authenticationMethod": "None",'+
            '   "returnUrl": "'+baseUrl +'/apex/'+pageName+'?Id='+currCaseId+'"'+   
            '}';     
        request.setBody(jsonPayload);
        response = httprequest.send(request); 
        system.debug('@@ response @@'+response);
        System.debug('@@ response.getbody @@'+response.getbody());
        System.debug('@@ response.getbody @@'+response.getStatusCode());
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
        
        List<dsfs__DocuSign_Recipient_Status__c> dbRecipientList = new List<dsfs__DocuSign_Recipient_Status__c> ();
        for(dsfs__DocuSign_Recipient_Status__c dbRecipnt : [SELECT Id,dsfs__Date_Sent__c,dsfs__Envelope_Id__c FROM dsfs__DocuSign_Recipient_Status__c WHERE dsfs__Envelope_Id__c =: envelop]){
            dsfs__DocuSign_Recipient_Status__c updatedsfsReci  = new dsfs__DocuSign_Recipient_Status__c ();
            updatedsfsReci .Id = dbRecipnt.Id;
            updatedsfsReci.dsfs__Date_Sent__c = system.Today();
            dbRecipientList.add(dbRecipnt);
        }
        
        if(dbRecipientList.size() > 0)
        update dbRecipientList;
        
        
        reference = new PageReference((String) results.get('url'));
        reference.setRedirect(true);
        return reference;
    }
}