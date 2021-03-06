public with sharing class FieloCMSELR_Modules {
	
	public static void onBeforeUpdate(List<FieloELR__Module__c> modules, Map<Id,FieloELR__Module__c> existingRecords){
		List<FieloCMS__Category__c> categories = new List<FieloCMS__Category__c>();
		for(FieloELR__Module__c module : modules){
			if(module.Name != existingRecords.get(module.Id).Name && module.FieloCMSELR_ContentCategory__c != null){
				categories.add(new FieloCMS__Category__c(Id = module.FieloCMSELR_ContentCategory__c, Name = module.Name));
			}
		}

		update categories;
	}
	
}