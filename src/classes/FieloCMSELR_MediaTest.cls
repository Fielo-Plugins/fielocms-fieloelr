@isTest
public with sharing class FieloCMSELR_MediaTest{
	
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

		FieloCMS__Media__c media = new FieloCMS__Media__c(
			Name = 'Media Test',
			FieloCMS__Category__c = module.FieloCMSELR_ContentCategory__c,
			FieloCMS__ExternalURL__c = 'http://www.indiewire.com/wp-content/uploads/2017/05/django-unchained-jamie-foxx.jpg'
		);

		insert media;

		media.FieloCMS__Category__c = course.FieloCMSELR_ContentCategory__c;

		String errorMsg = '';
		try{
			update media;
		}
		catch(Exception err ){
			errorMsg = err.getMessage();
		}
		System.assert(errorMsg.contains(Label.FieloCMSELR_MediaCategoryReadOnly));
	
	}

	@isTest static void ELRChangeCourseTest(){
		
		FieloELR__Module__c module = [SELECT Id, FieloELR__Course__c FROM FieloELR__Module__c WHERE Name = 'Basic'];
		
		FieloCMSELR_CourseService.relateToCategories(new Set<Id>{module.FieloELR__Course__c});
		
		FieloCMSELR_ModuleService.relateToCategories(new Set<Id>{module.Id});

		module = [SELECT Id, FieloCMSELR_ContentCategory__c, FieloELR__Course__c FROM FieloELR__Module__c WHERE Id =: module.Id];

		FieloELR__Course__c course = [SELECT Id, FieloCMSELR_ContentCategory__c FROM FieloELR__Course__c WHERE Id =:module.FieloELR__Course__c];

		FieloCMS__Media__c media = new FieloCMS__Media__c(
			Name = 'media test',
			FieloCMS__Category__c = course.FieloCMSELR_ContentCategory__c,
			FieloCMS__ExternalURL__c = 'http://www.indiewire.com/wp-content/uploads/2017/05/django-unchained-jamie-foxx.jpg'
		);
		insert media;

		media.FieloCMS__Category__c = module.FieloCMSELR_ContentCategory__c;

		String errorMsg = '';
		try{
			update media;
		}
		catch(Exception err ){
			errorMsg = err.getMessage();
		}
		System.assert(errorMsg.contains(Label.FieloCMSELR_MediaCategoryReadOnly));
	
	}
		

}