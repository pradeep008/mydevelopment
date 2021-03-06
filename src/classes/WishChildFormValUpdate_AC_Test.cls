/*****************************************************************************
Author : MST Solutions
CreateDate : 03/25/2016
Description :This WishChildFormValUpdate_AC_Test is used to cover the unit testing for WishChildFormValUpdate_AC.
Modification Log: 
23/03/2018 - Sankar - WVC-1835
******************************************************************************/
@isTest
public class WishChildFormValUpdate_AC_Test {
    //This method is used to create a case. 
    public static testMethod void createCase() {
        Case currentCase = OrientationandTrainingUtil.createParentCase();
        map<string,Case> caseDetails = new map<string,Case>();
        caseDetails.put(currentCase.id, currentCase);
        Wish_Child_Form__c newWish = new Wish_Child_Form__c();
        newWish.Case__c = currentCase.id;
        newWish.Case_Team_Member1__c = 'Member 1';
        newWish.Case_Team_Member2__c = 'Member 2';
        insert newWish;
        WishChildFormValUpdate_AC.updateWishType(caseDetails);
        System.assertEquals(newWish.Case_Team_Member1__c, 'Member 1','Team  member name is differ'); 
        System.assert(currentCase.id == newWish.Case__c,'Parent case Id doest not match with wish child form case Id');
    }
    //This method is used to update the wish details. 
    public static testMethod void callUpdateWishdetails(){
        Contact newCon = OrientationandTrainingUtil.CreateWishChild();
        Case currentCase = OrientationandTrainingUtil.createParentCase(newCon.Id);
        Case parentCase = OrientationandTrainingUtil.createParentCase();
        case wihdetermination = OrientationandTrainingUtil.createWishDeterminationCase(newCon.id, parentCase.id);
        map<Id,Case> caseDetails = new map<Id,Case>();
        caseDetails.put(currentCase.Id, currentCase);
        Wish_Child_Form__c newWish = new Wish_Child_Form__c();
        newWish.Case__c = currentCase.id;
        newWish.Case_Team_Member1__c = 'Member 1';
        newWish.Case_Team_Member2__c = 'Member 2';
        newWish.Wish_Determination_Case_Id__c = wihdetermination.id;
        insert newWish;
        WishChildFormValUpdate_AC.updateWishdetails(caseDetails);
        WishChildFormValUpdate_AC.updateWishdetails(caseDetails);
        System.assertEquals(newWish.Wish_Determination_Case_Id__c, wihdetermination.id,'Team  member name is differ'); 
        System.assert(currentCase.id == newWish.Case__c,'Parent case Id doest not match with wish child form case Id');
    }
    //This method is used to update the wish child and wish family. 
    public static testMethod void updateWishChildandWishFamily(){
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Account housholdAcc = OrientationandTrainingUtil.HouseHoldAccount();
        Contact newCon = OrientationandTrainingUtil.CreateWishChildwithAcc(housholdAcc.Id);
        Case parentCase = OrientationandTrainingUtil.createParentCase(newCon.Id);
        //Case currentCase = OrientationandTrainingUtil.createParentCase(newCon.Id);
        //case wihdetermination = OrientationandTrainingUtil.createWishDeterminationCase(newCon.id, parentCase.id);
        map<Id,Case> caseDetails = new map<Id,Case>();
        caseDetails.put(parentCase.Id, parentCase);
        Wish_Child_Form__c newWish = new Wish_Child_Form__c();
        newWish.Case__c = parentCase.id;
        newWish.Wish_Family_Contact__c = '[{"workTelephone":"","tshirtSize":null,"residingWishMedical":null,"relId":"0035B000004R9vwQAC","relationship":"Father","mobileTelephone":"(878) 787-8787","MiddleName":"","medicalNeeds":null,"lastName":"Test12","homeTelephone":"","firstName":"Test12","Email":"kanagaraj@mstsolutions.com","dob":"2016-11-29"},{"workTelephone":"","tshirtSize":null,"residingWishMedical":null,"relId":"0035B000004R9vuQAC","relationship":"Mother","mobileTelephone":"(878) 787-8787","MiddleName":"","medicalNeeds":null,"lastName":"TestPL1","homeTelephone":"","firstName":"TestPF1","Email":"kanagu431@gmail.com","dob":"2016-11-28"}]';
        newWish.Driver_Details__c = '[{"type":"Potential","state":"Alaska","licenseNum":"Tamil Nadu","expirationDate":"2017-01-04","driverName":"Test12 Test12"}]';
        newWish.Participant_Contacts__c = '[{"workTelephone":null,"tshirtSize":"","residingWishMedical":"Yes","relId":null,"relationship":"Father","mobileTelephone":null,"MiddleName":"","medicalNeeds":"Yes","lastName":"Test12","homeTelephone":null,"firstName":"Test12","Email":"kanagaraj@mstsolutions.com","dob":"2000-11-29"},{"workTelephone":null,"tshirtSize":"","residingWishMedical":"Yes","relId":null,"relationship":"Mother","mobileTelephone":null,"MiddleName":"","medicalNeeds":"Yes","lastName":"TestPL1","homeTelephone":null,"firstName":"TestPF1","Email":"kanagu431@gmail.com","dob":"2000-11-29"}]';
        newWish.LastName__c = 'Test Name';
        newWish.Case_Team_Member1__c = 'Member 1';
        newWish.Case_Team_Member2__c = 'Member 2';
       // newWish.Wish_Determination_Case_Id__c = wihdetermination.id;
        insert newWish;
        Test.startTest();
        WishChildFormValUpdate_AC.UpdateWishChildandWishFamily(caseDetails);
        WishChildFormValUpdate_AC.UpdateWishChildandWishFamily(caseDetails);
        Test.stopTest();
        System.assertEquals(newWish.Case_Team_Member1__c, 'Member 1','Team  member name is differ'); 
        System.assert(parentCase.id == newWish.Case__c,'Parent case Id doest not match with wish child form case Id');
    }
    
}