public class WishGranting_AC{
    
    public List<WishGrantingWrapper> wishGrantingWrapperList{get;set;}
    public Wish_Child_Form__c currWishChild{get;set;}
    public Id currentPageId{get;set;}
    Public string childName{get;set;}
    public boolean displaypopup{get;set;}
    Public String receipantName{get;set;}
    Public List<dsfs__DocuSign_Recipient_Status__c> docusignStatusList{get;set;}
    public integer i{get;set;}
    public String formStatus{get;set;}
    Public String guardian{get;set;}
    public string miniorParticipantName{get;set;}
    Public List<SelectOption> ParentGurdianList{get;set;}
    Public List<SelectOption> formselectionList{get;set;}
    public boolean displayguardian{get;set;}
    public Map<String,String> participantMap; 
    public String Name{get;set;}
    public String email{get;set;}
    public Map<String,String> recipientMap;
    public string selectedForm{get;set;} 
    public integer n =0;
    public integer m = 0;
    public boolean deletePopup{get;set;}
    Public String  docuEnve;
    Public String  styleOption{get;set;}
    public boolean validation{get;set;}
    public WishGranting_AC(){
        integer j = 0;
        integer k = 0;
        integer l = 0;
        displaypopup = false;
        displayguardian = false;
        deletePopup = false;
        currentPageId =  ApexPages.currentPage().getParameters().get('id');
        ParentGurdianList = new List<SelectOption>();
        formselectionList = new List<SelectOption>();
        participantMap = new Map<String,String>();
        recipientMap = new Map<String,String>();
        wishGrantingWrapperList = new List<WishGrantingWrapper>();
        currWishChild =[SELECT Id,Case__c,Wish_Family_Contact__c,BirthDate__c,Participant_Contacts__c,Participant_Under_18__c,FirstName__c,LastName__c,Middle_Name__c,Email__c,Case__r.ContactId,Case__r.Contact.Name FROM Wish_Child_Form__c WHERE Case__c =: currentPageId ];
        List<Minor_Participant__c> dbMinorList = [SELECT Id,Name,Associated_Childeren__c,Case__c,Email__c,Form_Name__c,Guardian_Name__c,Name__c FROM Minor_Participant__c WHERE Case__c =:currentPageId];
        childName = currWishChild.FirstName__c+' '+currWishChild.LastName__c;
        
        List<String> formList = new List<String>();
        formList.add('Wish Form & Liability Form');
        formList.add('Liability Form');
        formselectionList.add(new SelectOption('Wish Form & Liability Form','Wish Form & Liability Form'));
        formselectionList.add(new SelectOption('Liability Form','Liability Form'));
        if(currWishChild.Wish_Family_Contact__c != Null){
            ParentGuardianJSON2Apex  ParentGuIns = new ParentGuardianJSON2Apex();
            List<ParentGuardianJSON2Apex> parentGuardianList = new List<ParentGuardianJSON2Apex>();
            String json = string.valueof(currWishChild.Wish_Family_Contact__c);
            json = json.replace('&quot;', '"');
            json = json.replace('&amp;', '&');
            json = json.replace('&#39;', '\'');
            
            parentGuardianList = ParentGuIns.parse(json);
            
            for(ParentGuardianJSON2Apex processString : parentGuardianList){
                
                
                WishGrantingWrapper wrapperIns = new WishGrantingWrapper();
                wrapperIns.name = processString.FirstName+' '+processString.lastname;
                wrapperIns.relationship = processString.Relationship;
                wrapperIns.unsigned = inCompletedRecipient(wrapperIns.name);
                wrapperIns.signed = completedRecipient(wrapperIns.name);
                if(wrapperIns.unsigned == 0 && wrapperIns.signed == 0)
                {
                    j = 1;
                } 
                if(wrapperIns.signed == 0){
                   k = 1;
                }
                if(wrapperIns.unsigned >= wrapperIns.signed)
                {
                     k = 1;
                }
                if(wrapperIns.unsigned <  wrapperIns.signed)
                {
                     l = 1;
                }
                string formstatus = checkEnvelopSent(wrapperIns.name);
                if(formstatus == 'Not Sent'){
                    wrapperIns.forms = 'Send';
                }
                else{
                    wrapperIns.forms = 'View';
                }
                
                wishGrantingWrapperList.add(wrapperIns);
                participantMap.put(processString.FirstName+' '+processString.lastname,processString.Email);
                ParentGurdianList.add(new SelectOption(wrapperIns.name,wrapperIns.name));
                
            }
        }
        
        if(currWishChild.Participant_Contacts__c != Null){
            ParticipantJSON2Apex  ParticipantIns = new ParticipantJSON2Apex();
            List<ParticipantJSON2Apex> prticipantList = new List<ParticipantJSON2Apex>();
            String particiapant = string.valueof(currWishChild.Participant_Contacts__c);
            particiapant = particiapant.replace('&quot;', '"');
            particiapant = particiapant.replace('&amp;', '&');
            particiapant = particiapant.replace('&#39;', '\'');
            
            prticipantList = ParticipantIns.parse(particiapant);
            
            for(ParticipantJSON2Apex  processString : prticipantList){
                Date dt = Date.Valueof(processString.dob);
                Integer days = dt.daysBetween(Date.Today());
                Integer age = Integer.valueOf(days/365);
                if(age >= 18){
                    WishGrantingWrapper wrapperIns = new WishGrantingWrapper();
                    wrapperIns.name = processString.FirstName+' '+processString.lastname;
                    wrapperIns.relationship = processString.Relationship;
                    wrapperIns.unsigned = inCompletedRecipient(wrapperIns.name);
                    wrapperIns.signed = completedRecipient(wrapperIns.name);
                    if(wrapperIns.unsigned == 0 && wrapperIns.signed == 0)
                    {
                        j = 1;
                    } 
                    if(wrapperIns.signed == 0){
                        k = 1;
                    }
                    if(wrapperIns.unsigned >= wrapperIns.signed)
                    {
                        k = 1;
                    }
                    if(wrapperIns.unsigned <  wrapperIns.signed)
                    {
                        l = 1;
                    }
                    
                    wishGrantingWrapperList.add(wrapperIns);
                    participantMap.put(processString.FirstName+' '+processString.lastname,processString.Email);
                    recipientMap.put(processString.FirstName+' '+processString.lastname,'participent');
                    ParentGurdianList.add(new SelectOption(wrapperIns.name,wrapperIns.name));
                }
            }
        }
        
        if(currWishChild.BirthDate__c != Null){
            Date dt = Date.Valueof(currWishChild.BirthDate__c);
            Integer days = dt.daysBetween(Date.Today());
            Integer age = Integer.valueOf(days/365);
            if(age >= 18){
                WishGrantingWrapper wrapperIns = new WishGrantingWrapper();
                wrapperIns.name = currWishChild.FirstName__c+' '+currWishChild.LastName__c;
                wrapperIns.relationship = 'Wish Child';
                wrapperIns.unsigned = inCompletedRecipient(wrapperIns.name);
                wrapperIns.signed = completedRecipient(wrapperIns.name);
                if(wrapperIns.unsigned == 0 && wrapperIns.signed == 0)
                    {
                        j = 1;
                    } 
                    if(wrapperIns.signed == 0){
                        k = 1;
                    }
                    if(wrapperIns.unsigned >= wrapperIns.signed)
                    {
                        k = 1;
                    }
                    if(wrapperIns.unsigned <  wrapperIns.signed)
                    {
                        l = 1;
                    }
                string formstatus = checkEnvelopSent(wrapperIns.name);
                if(formstatus == 'Not Sent'){
                    wrapperIns.forms = 'Send';
                }
                else{
                    wrapperIns.forms = 'View';
                }
                
                wishGrantingWrapperList.add(wrapperIns);
                participantMap.put(currWishChild.FirstName__c+' '+currWishChild.LastName__c,currWishChild.Email__c);
                recipientMap.put(currWishChild.FirstName__c+' '+currWishChild.LastName__c,'Wish Child');
                ParentGurdianList.add(new SelectOption(wrapperIns.name,wrapperIns.name));
            }
        }
        
        if(dbMinorList.size() > 0){
            set<String> dupset = new Set<String>();
            for(Minor_Participant__c dbMinor : dbMinorList){
                String dupString = dbMinor.Name__c+' '+dbMinor.email__c;
                if(!dupset.contains(dupString)){
                    WishGrantingWrapper wrapperIns = new WishGrantingWrapper();
                    wrapperIns.name = dbMinor.Name__c;
                    wrapperIns.relationship = 'Parent of Minor';
                    wrapperIns.unsigned = inCompletedRecipient(wrapperIns.name) ;
                    wrapperIns.signed = completedRecipient(wrapperIns.name);
                    if(wrapperIns.unsigned == 0 && wrapperIns.signed == 0)
                    {
                        j = 1;
                    } 
                    if(wrapperIns.signed == 0){
                        k = 1;
                    }
                    if(wrapperIns.unsigned >= wrapperIns.signed)
                    {
                        k = 1;
                    }
                    if(wrapperIns.unsigned <  wrapperIns.signed)
                    {
                        l = 1;
                    }
                    string formstatus = checkEnvelopSent(wrapperIns.name);
                    if(formstatus == 'Not Sent'){
                        wrapperIns.forms = 'Send';
                    }
                    else{
                        wrapperIns.forms = 'View';
                    }
                    dupset.add(dbMinor.Name__c+' '+dbMinor.Email__c);
                    wishGrantingWrapperList.add(wrapperIns);
                }
            }
        }
        
        ParentGurdianList.add(new SelectOption('Not listed','Not listed'));
        if(j == 0 && k ==0 && l == 1){
            formStatus = 'Completed';
        }
        if( k == 1 || j == 1){
            formStatus = 'Pending';
        }
         
    } 
    public void displaypopup(){
        displayguardian = false;
        displaypopup = true;
        docusignStatusList = new List<dsfs__DocuSign_Recipient_Status__c>();
        receipantName = ApexPages.currentPage().getParameters().get('rename');
        
        
        for(dsfs__DocuSign_Recipient_Status__c dbdocStatusRec : [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__c,dsfs__Recipient_Status__c,dsfs__Parent_Status_Record__r.dsfs__Case__c, 
                                                                 dsfs__Parent_Status_Record__r.dsfs__Subject__c,dsfs__Parent_Status_Record__r.AttachmentId__c,dsfs__Date_Signed__c,dsfs__Date_Sent__c,dsfs__Date_Delivered__c,dsfs__Parent_Status_Record__r.Associated_Childeren__c FROM dsfs__DocuSign_Recipient_Status__c WHERE Name =: receipantName   
                                                                 AND dsfs__Parent_Status_Record__r.dsfs__Case__c =: currentPageId]){
                                                                     if(dbdocStatusRec .dsfs__Parent_Status_Record__r.dsfs__Subject__c  == 'Signature Required - Wish Form & Liability And Publicity Release Form' || dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c == 'Signature Required - Liability And Publicity Release Form'){
                                                                         i = 1;
                                                                         if(dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  == 'Signature Required - Wish Form & Liability And Publicity Release Form')
                                                                             dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  =  'Wish Form & Liability And Publicity Release Form';
                                                                         if(dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  == 'Signature Required - Liability And Publicity Release Form')
                                                                             dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  =  'Liability And Publicity Release Form';
                                                                         
                                                                         docusignStatusList.add(dbdocStatusRec);
                                                                         i++;
                                                                     }
                                                                 }
    }   
    
    public integer completedRecipient(string recipientName){
        List<String> completedFormList = new List<String>();
        
        for(dsfs__DocuSign_Status__c dbdocStatusRec : [SELECT Id,Name,dsfs__Case__c,dsfs__Envelope_Status__c,Recipient_names__c,dsfs__Subject__c,dsfs__Sent_Date_Time__c,dsfs__Completed_Date_Time__c FROM dsfs__DocuSign_Status__c  WHERE Recipient_names__c =: recipientName AND Recipient_names__c != Null AND dsfs__Case__c =: currentPageId ]){
            
            if(dbdocStatusRec.dsfs__Envelope_Status__c == 'Completed' && dbdocStatusRec.dsfs__Completed_Date_Time__c != Null){
                completedFormList.add(dbdocStatusRec.Name);
            }
       }
         return completedFormList.size();
    }
    
    public integer inCompletedRecipient(string recipientName){
        List<String> inCompletedFormList = new List<String>();
        
        for(dsfs__DocuSign_Status__c dbdocStatusRec : [SELECT Id,Name,dsfs__Case__c,dsfs__Envelope_Status__c,Recipient_names__c,dsfs__Subject__c,dsfs__Sent_Date_Time__c,dsfs__Completed_Date_Time__c FROM dsfs__DocuSign_Status__c  WHERE Recipient_names__c =: recipientName AND Recipient_names__c != Null AND dsfs__Case__c =: currentPageId ]){
            
            if(dbdocStatusRec.dsfs__Envelope_Status__c != 'Completed'){
                inCompletedFormList .add(dbdocStatusRec.Name);
            }
       }
       return inCompletedFormList.size();
    }
    
    public string checkEnvelopSent(string recipientName){
        String subject = '';
        for(dsfs__DocuSign_Status__c dbdocStatusRec : [SELECT Id,Name,dsfs__Case__c,dsfs__Envelope_Status__c,Recipient_names__c,dsfs__Subject__c,dsfs__Sent_Date_Time__c,dsfs__Completed_Date_Time__c FROM dsfs__DocuSign_Status__c  WHERE dsfs__Case__c =: currentPageId ]){
            if(dbdocStatusRec.Id != Null && dbdocStatusRec.Recipient_names__c == recipientName){
                subject = dbdocStatusRec.dsfs__Subject__c;
            }
        }
        if(subject == ''){
            subject = 'Not Sent';
        }
        return subject;
    }
    
    public void sendEnvelopId(){
        displaypopup = false;
        String envId = ApexPages.currentPage().getParameters().get('envelopId');
        List<dsfs__DocuSign_Recipient_Status__c> dbRecipient = [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__c,dsfs__Parent_Status_Record__r.Form_Name__c,dsfs__Recipient_Status__c FROM dsfs__DocuSign_Recipient_Status__c WHERE dsfs__Envelope_Id__c =: envId Limit 1];
        
        ResendEnvelopController resendEnv = new ResendEnvelopController();
        resendEnv.resendEnvelop(envId,dbRecipient[0].Name,dbRecipient[0].dsfs__DocuSign_Recipient_Email__c);
        
    }
    
    public pageReference singNowEnvelop(){
        pageReference reference;
        displaypopup = false;
        String envId = ApexPages.currentPage().getParameters().get('envelopId');
        List<dsfs__DocuSign_Recipient_Status__c> dbRecipient = [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__r.dsfs__Case__c,dsfs__Parent_Status_Record__r.dsfs__Subject__c FROM dsfs__DocuSign_Recipient_Status__c WHERE dsfs__Envelope_Id__c =: envId Limit 1];
        ResendEnvelopController resendEnv = new ResendEnvelopController();
        string pageName;
        if(dbRecipient[0].dsfs__Parent_Status_Record__r.dsfs__Subject__c == 'Signature Required - Wish Form & Liability And Publicity Release Form'){
            
            pageName = 'WishFormWishGranting_VF';
            
        }
        if(dbRecipient[0].dsfs__Parent_Status_Record__r.dsfs__Subject__c == 'Signature Required - Liability And Publicity Release Form'){
            
            pageName = 'WishLiabilityWishGranting_VF' ;  
        }
        
        return resendEnv.signNowEnvelop(envId,dbRecipient[0].Name,dbRecipient[0].dsfs__Parent_Status_Record__r.dsfs__Case__c,pageName);    
    }
    
    
    //Display the list of minor participant
    public List<SelectOption> getMinorParticipantList() {
        List<SelectOption> minorParticipantList = new List<SelectOption>();
        If(currWishChild.Participant_Under_18__c != Null){
            for(String processName : (currWishChild.Participant_Under_18__c).split(',')){
                minorParticipantList.add(new SelectOption(processName,processName ));                                 
            }
        }
        minorParticipantList.add(new SelectOption(currWishChild.FirstName__c+' '+currWishChild.LastName__c,currWishChild.FirstName__c+' '+currWishChild.LastName__c));  
        return minorParticipantList;
    }
    
    public void displayGuardianPopup(){
        displaypopup = false;
        displayguardian = true;
        Name = null;
        guardian = null;
        selectedForm = null;
        email = null;
       
    }
    public void updateEmailValue(){
        displayguardian = true;
        if(participantMap.size() > 0)
            email = participantMap.get(guardian);
        else
            email = '';
    }
    public void cancel(){
        displaypopup = false;
        displayguardian = false;
        deletePopup = false;
        
    }
    
    public void sendEnvelopfromPopup(){
        WishGranting_AC wishGrant = new WishGranting_AC();
        Map<String,String> emailMap = new Map<String,String>();
        checkEmail(email);
        
        if((Name == Null && guardian  == Null) || selectedForm == Null || string.isEmpty(email) || miniorParticipantName == '[]' || validation == true){
            displayErrorMessage();
        }
        
        if(guardian != 'Not listed'){
            
            for(dsfs__DocuSign_Recipient_Status__c dbRecipient : [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__c,dsfs__Parent_Status_Record__r.Form_Name__c,dsfs__Recipient_Status__c,
                                                                  dsfs__Parent_Status_Record__r.dsfs__Case__c FROM dsfs__DocuSign_Recipient_Status__c WHERE dsfs__Parent_Status_Record__r.dsfs__Case__c =: currentPageId]){
                                                                      
                                                                      
                      if (dbRecipient.Name == guardian && dbRecipient.dsfs__DocuSign_Recipient_Email__c == email && dbRecipient.dsfs__Parent_Status_Record__r.Form_Name__c == selectedForm && dbRecipient.dsfs__Recipient_Status__c == 'Completed'){
                          n = 1;
                          displayErrorMessage();
                      }
            }
        }
        
        if(guardian != 'Not listed' && n == 0 && validation == false) {
            
            emailMap.put(guardian,email);
            if(selectedForm == 'Wish Form & Liability Form'){
                m = 1;
                n = 1;
                displayErrorMessage();
                WishChildForm_AC.callouttoDocusing(emailMap,currentPageId,currWishChild.Case__r.ContactId,miniorParticipantName);
            }
            if(selectedForm == 'Liability Form'){
                 m = 1;
                 n = 1;
                displayErrorMessage();
                WishLiabilityForm_AC.callOuttoDocusign(emailMap,currentPageId,'Three',miniorParticipantName);
            } 
        }
        
        if(guardian == 'Not listed' && validation == false){
            List<Minor_Participant__c> minorParticipantList = new List<Minor_Participant__c>();
            List<Minor_Participant__c> dbMinorParticipantList = [SELECT Id,Name__c,Associated_Childeren__c,Case__c,Form_Name__c,Email__c FROM Minor_Participant__c  WHERE Case__c =: currentPageId];
            String minorPartname = miniorParticipantName;
            string name1 = minorPartname.removeStart('[');
            string AssosiatedChilderen= name1.removeEnd(']');
            
            
            if(dbMinorParticipantList.size() == 0 ){
                
                Minor_Participant__c newMinorRec = new Minor_Participant__c();
                newMinorRec.Name__c = Name;
                newMinorRec.Associated_Childeren__c = AssosiatedChilderen;
                newMinorRec.Case__c = currentPageId;
                newMinorRec.Email__c = email;
                newMinorRec.Guardian_Name__c = guardian;
                newMinorRec.Form_Name__c = selectedForm; 
                minorParticipantList.add(newMinorRec);
               
            }
            if(dbMinorParticipantList.size() > 0 ){
                
                Minor_Participant__c newMinorRec = new Minor_Participant__c();
                newMinorRec.Name__c = Name;
                newMinorRec.Associated_Childeren__c = AssosiatedChilderen;
                newMinorRec.Case__c = currentPageId;
                newMinorRec.Email__c = email;
                newMinorRec.Guardian_Name__c = guardian;
                newMinorRec.Form_Name__c = selectedForm;
                minorParticipantList.add(newMinorRec); 
                   
             }
              if(minorParticipantList.size() > 0){
                
                    insert minorParticipantList;
                    
                    emailMap.put(minorParticipantList[0].Name__c ,minorParticipantList[0].Email__c );
                    if(selectedForm == 'Wish Form & Liability Form'){
                         m = 1;
                         n = 1;
                         displayErrorMessage();
                        WishChildForm_AC.callouttoDocusing(emailMap,currentPageId,currWishChild.Case__r.ContactId,miniorParticipantName);
                    }
                    if(selectedForm == 'Liability Form'){
                         m = 1;
                         n = 1;
                         displayErrorMessage();
                        WishLiabilityForm_AC.callOuttoDocusign(emailMap,currentPageId,'Three',miniorParticipantName);
                    } 
                    
                }   
        }
    }
    public void reSendParticipantEnv(){
        
        for(dsfs__DocuSign_Recipient_Status__c dbRecipient : [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__c,dsfs__Parent_Status_Record__r.Form_Name__c,dsfs__Recipient_Status__c,
                                                              dsfs__Parent_Status_Record__r.dsfs__Case__c FROM dsfs__DocuSign_Recipient_Status__c WHERE dsfs__Parent_Status_Record__r.dsfs__Case__c =: currentPageId]){
                                                                  
                                                                  if(dbRecipient.Name == Name && dbRecipient.dsfs__DocuSign_Recipient_Email__c == email && dbRecipient.dsfs__Parent_Status_Record__r.Form_Name__c == selectedForm && dbRecipient.dsfs__Recipient_Status__c != 'Completed'){
                                                                      n = 1;
                                                                      m = 1;
                                                                      displayErrorMessage();
                                                                      ResendEnvelopController resendEnv = new ResendEnvelopController();
                                                                      resendEnv.resendEnvelop(dbRecipient.dsfs__Envelope_Id__c,dbRecipient.Name,dbRecipient.dsfs__DocuSign_Recipient_Email__c);
                                                                  }
                                                                  else if (dbRecipient.Name == guardian && dbRecipient.dsfs__DocuSign_Recipient_Email__c == email && dbRecipient.dsfs__Parent_Status_Record__r.Form_Name__c == selectedForm && dbRecipient.dsfs__Recipient_Status__c == 'Completed'){
                                                                      n = 1;
                                                                      displayErrorMessage();
                                                                  }
                                                              }
        
    }
    
    /*****************************************************************************************************
It redirect to the File  Upload page when the wish fomr in Submit for approval Process.
******************************************************************************************************/
    public pageReference UploadFile(){       
        pageReference reference;
        reference = new PageReference('/apex/WishFormAttachments_VF?id='+currentPageId);
        reference.setRedirect(true);
        return reference;
    }
    
     //Used to save new attachment theat attached from Wish child form
    public void saveAttachment() {
        Attachment newAttachment = new Attachment();
        if (newAttachment.Body!=null) {
            newAttachment.parentId = currentPageId;
            insert newAttachment;  
        }
    }
    
    public void displayDletePopup(){
        docuEnve = ApexPages.currentPage().getParameters().get('envelopId');
        displaypopup = false;
        deletePopup = true;
    }
    
    public void deleteStatusRec(){
        deletePopup = false;
        List<dsfs__DocuSign_Status__c > dbStatusRecList = [SELECT Id,dsfs__DocuSign_Envelope_ID__c FROM dsfs__DocuSign_Status__c WHERE dsfs__DocuSign_Envelope_ID__c =: docuEnve];
        If(dbStatusRecList.size() > 0)
        delete dbStatusRecList;
    }
    
     public void checkEmail(string email){
        
        if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', email))
        {   //allowCallout = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter a valid email address.')); 
            validation = true;
        }
        else{
            validation = false;
        }
       
      }
    
     
    public String displayErrorMessage(){
        styleOption = '';
        system.debug('@@@ validation @@@'+validation);
        
        if(selectedForm == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select which form you need to send.'));
            styleOption = 'Please select which form you need to send.';
        } 
        if(miniorParticipantName == '[]'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Signing on Behalf of .'));
            styleOption = 'Please select Signing on Behalf of.';
        }
        if(validation == true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter a valid email address.')); 
            styleOption = 'Please enter a valid email address.';
        }
        if(string.isEmpty(email)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter email.'));
            styleOption = 'Please enter email.';
        }
         if(string.isEmpty(Name) && guardian == 'Not listed'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter parent name.'));
            styleOption = 'Please enter parent name.';
         } 
        
        if(guardian  == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Recipient from guardian or enter name.'));
            styleOption = 'Please select Recipient from guardian or enter name.';
         }
        
        if(n == 1 && m == 1){
           
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'The form has been sent successfully.'));
            styleOption = 'success';
            displayguardian = false;
            
        }            
        return null;
    }
    
    
    public class WishGrantingWrapper{
        public string name{get;set;}
        public string relationship{get;set;}
        public integer signed{get;set;}
        public integer unsigned{get;set;}
        public string forms{get;set;}
        
    }    
}