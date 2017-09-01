public with sharing class FieloCMSELR_QuizCtrl implements FieloCMS.ViewInterface{
	public ApexPages.Component getComponent(FieloCMS__Component__c c){
        Component.FieloCMSELR_Quiz quiz = new Component.FieloCMSELR_Quiz(config = c);
        return quiz;        
    }

    @RemoteAction
    public static FieloELR.QuestionService.QuestionResponseResult submitQuestion(FieloELR.QuestionService.QuestionResponseWrapper questionResponseWrapper) {
        return FieloELR.QuestionService.submitQuestion(questionResponseWrapper);
    }

    @RemoteAction
    public static FieloELR__ModuleResponse__c submitModuleResponse(FieloELR__ModuleResponse__c moduleResponse) {
        return FieloELR.ModuleService.submitModuleResponse(moduleResponse);
    }
}