public with sharing class FieloCMSELR_Media{
	
	public static void onBeforeUpdate(List<FieloCMS__Media__c> media, Map<Id,FieloCMS__Media__c> existingRecords){
		Set<Id> categoryIds = new Set<Id>();

		for (FieloCMS__Media__c medium : media){
			categoryIds.add(medium.FieloCMS__Category__c);
		}
		 //Querry to get Category and Module Ids
		Map<Id, FieloCMS__Category__c> categoriesMap = new Map<Id, FieloCMS__Category__c>([SELECT Id, (SELECT Id FROM ContentModules__r LIMIT 1), (SELECT Id FROM ContentCourses__r LIMIT 1) FROM FieloCMS__Category__c WHERE Id in :categoryIds]);
	
		for (FieloCMS__Media__c medium : media){
		    //Validate it to not return a get Null error
			if(categoriesMap.containsKey(medium.FieloCMS__Category__c)){   
			 //Check if there is a module
				if(!categoriesMap.get(medium.FieloCMS__Category__c).ContentModules__r.isEmpty() || !categoriesMap.get(medium.FieloCMS__Category__c).ContentCourses__r.isEmpty()){
					if(medium.FieloCMS__Category__c != existingRecords.get(medium.Id).FieloCMS__Category__c){
						medium.addError(Label.FieloCMSELR_MediaCategoryReadOnly);
					}
				}
			}
		}
	}
}