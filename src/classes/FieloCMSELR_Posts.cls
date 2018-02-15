public with sharing class FieloCMSELR_Posts{
		
	public static void onBeforeUpdate(List<FieloCMS__Post__c> posts, Map<Id,FieloCMS__Post__c> existingRecords){
		Set<Id> categoryIds = new Set<Id>();

		for (FieloCMS__Post__c post : posts){
			categoryIds.add(post.FieloCMS__Category__c);
		}
		Map<Id, FieloCMS__Category__c> categoriesMap = new Map<Id, FieloCMS__Category__c>([SELECT Id, (SELECT Id FROM ContentModules__r LIMIT 1), (SELECT Id FROM ContentCourses__r LIMIT 1) FROM FieloCMS__Category__c WHERE Id in :categoryIds]);


		for (FieloCMS__Post__c post : posts){
			if (categoriesMap.containsKey(post.FieloCMS__Category__c)){

				if(!categoriesMap.get(post.FieloCMS__Category__c).ContentModules__r.isEmpty() || !categoriesMap.get(post.FieloCMS__Category__c).ContentCourses__r.isEmpty()){

					if(post.FieloCMS__Category__c != existingRecords.get(post.Id).FieloCMS__Category__c){
						post.addError(Label.FieloCMSELR_PostCategoryReadOnly);
					}
				}
			}	
		}
		

	}
}