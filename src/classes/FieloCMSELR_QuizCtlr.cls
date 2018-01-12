global with sharing class FieloCMSELR_QuizCtlr{
    @RemoteAction
    global static FieloELR.QuestionService.QuestionResponseResult submitQuestion(FieloELR.QuestionService.QuestionResponseWrapper questionResponseWrapper) {
        return FieloELR.QuestionService.submitQuestion(questionResponseWrapper);
    }

    @RemoteAction
    global static FieloELR__ModuleResponse__c submitModuleResponse(FieloELR__ModuleResponse__c moduleResponse) {
        return FieloELR.ModuleService.submitModuleResponse(moduleResponse);
    }
    
    public String pathPrefix { get{
        if (pathPrefix==null) {
            if (!Test.isRunningTest()) {
                pathPrefix = Site.getPathPrefix();
            } else {
                pathPrefix = '';
            }
        }
        return pathPrefix;
    }
        set;
    }
}