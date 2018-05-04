@isTest
public with sharing class FieloCMSELR_PostTest{
	
	//Method that creates the Test Data with 3 Modules 'Basic'
	@testSetup static void setup(){
		MockUpFactory.InsertTestData();
	}

	@isTest static void ELRChangeModuleTest(){
		
		FieloELR__Module__c module = [SELECT Id, FieloELR__Course__c FROM FieloELR__Module__c WHERE Name = 'Basic'];
		
		FieloCMSELR_CourseService.relateToCategories(new Set<Id>{module.FieloELR__Course__c});
		
		FieloCMSELR_ModuleService.relateToCategories(new Set<Id>{module.Id});

		module = [SELECT Id, FieloCMSELR_ContentCategory__c, FieloELR__Course__c FROM FieloELR__Module__c WHERE Id =: module.Id];

		
		FieloELR__Course__c course = [SELECT Id, FieloCMSELR_ContentCategory__c FROM FieloELR__Course__c WHERE Id =:module.FieloELR__Course__c];

		FieloCMS__Post__c post = new FieloCMS__Post__c(
			Name = 'Post',
			FieloCMS__Category__c = module.FieloCMSELR_ContentCategory__c,
			FieloCMS__Content__c = 'Test'
		);

		insert post;

		post.FieloCMS__Category__c = course.FieloCMSELR_ContentCategory__c;

		String errorMsg = '';
		try{
			update post;
		}
		catch(Exception err ){
			errorMsg = err.getMessage();
		}
		System.assert(errorMsg.contains(Label.FieloCMSELR_PostCategoryReadOnly));
	
	}

	@isTest static void ELRChangeCourseTest(){
		
		FieloELR__Module__c module = [SELECT Id, FieloELR__Course__c FROM FieloELR__Module__c WHERE Name = 'Basic'];
		
		FieloCMSELR_CourseService.relateToCategories(new Set<Id>{module.FieloELR__Course__c});
		
		FieloCMSELR_ModuleService.relateToCategories(new Set<Id>{module.Id});

		module = [SELECT Id, FieloCMSELR_ContentCategory__c, FieloELR__Course__c FROM FieloELR__Module__c WHERE Id =: module.Id];

		FieloELR__Course__c course = [SELECT Id, FieloCMSELR_ContentCategory__c FROM FieloELR__Course__c WHERE Id =:module.FieloELR__Course__c];

		FieloCMS__Post__c post = new FieloCMS__Post__c(
			Name = 'Post',
			FieloCMS__Category__c = course.FieloCMSELR_ContentCategory__c,
			FieloCMS__Content__c = 'Test'
		);
		insert post;

		post.FieloCMS__Category__c = module.FieloCMSELR_ContentCategory__c;

		String errorMsg = '';
		try{
			update post;
		}
		catch(Exception err ){
			errorMsg = err.getMessage();
		}
		System.assert(errorMsg.contains(Label.FieloCMSELR_PostCategoryReadOnly));
	
	}
		

}