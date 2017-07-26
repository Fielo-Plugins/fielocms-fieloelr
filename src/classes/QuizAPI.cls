global with sharing class QuizAPI implements FieloCMS.ViewInterface{
	global ApexPages.Component getComponent(FieloCMS__Component__c c){
        Component.Widget3 quiz = new Component.Widget3(config = c);
        return quiz;        
    }

    @RemoteAction
    global static FieloELR.QuestionService.QuestionResponseResult submitQuestion(FieloELR.QuestionService.QuestionResponseWrapper questionResponseWrapper) {
    	System.debug(questionResponseWrapper);
        return FieloELR.QuestionService.submitQuestion(questionResponseWrapper);
    }

    @RemoteAction
    global static FieloELR__ModuleResponse__c submitModuleResponse(FieloELR__ModuleResponse__c moduleResponse) {
    	System.debug(moduleResponse);
        return FieloELR.ModuleService.submitModuleResponse(moduleResponse);
    }
}