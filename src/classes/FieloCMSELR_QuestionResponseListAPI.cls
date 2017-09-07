global with sharing class FieloCMSELR_QuestionResponseListAPI implements FieloCMS.ViewInterface {
    public ApexPages.Component getComponent(FieloCMS__Component__c c){
        Component.FieloCMSELR_QuestionResponseList qResp = new Component.FieloCMSELR_QuestionResponseList(config = c);
        return qResp;        
    }
}