global with sharing class FieloCMSELR_QuizAPI implements FieloCMS.ViewInterface {
	public ApexPages.Component getComponent(FieloCMS__Component__c c){
       	Component.FieloCMSELR_Quiz quiz = new Component.FieloCMSELR_Quiz(config = c);
        return quiz;
    }
}