public class FieloCMSELR_QuestionResponseListCtlr {
    public FieloELR.ModuleService.ModuleResponseResult moduleResponseResult {get {
        if(moduleResponseResult == null){
            Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
            FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
            Id moduleResponseId = ApexPages.CurrentPage().getParameters().get('id');
            moduleResponseResult = FieloELR.ModuleService.getModuleResponse(
                moduleResponseId,
                new Set<String> {'Name','FieloELR__Module__r.FieloELR__Course__c'},
                new Set<String> {'Name','FieloELR__Type__c','FieloELR__Module__r.FieloELR__Course__c','FieloELR__QuestionText__c'},
                new Set<String> {'FieloELR__Question__c','FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c'}
            );
        }
        return moduleResponseResult;
    } set;}

    public String courseId {get{
        if (moduleResponseResult != null) {
            return (String) moduleResponseResult.moduleResponse.FieloELR__Module__r.FieloELR__Course__c;
        } else {
            return '';
        }
    }
        set;
    }
}