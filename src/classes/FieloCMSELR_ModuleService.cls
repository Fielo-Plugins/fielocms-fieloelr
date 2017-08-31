public with sharing class FieloCMSELR_ModuleService {
	
	public static void relateToCategories(Set<Id> moduleIds){
		SavePoint sp = Database.setSavePoint();
		try{
			Set<String> categoryNames = new Set<String>();
			Map<Id,FieloELR__Module__c> modulesMap = new Map<Id,FieloELR__Module__c>([SELECT Id, Name, ContentCategory__c, FieloELR__Course__r.ContentCategory__c FROM FieloELR__Module__c WHERE ContentCategory__c = null AND Id in : moduleIds]);
			for(FieloELR__Module__c module : modulesMap.values()){
				categoryNames.add(module.Name);
			}

			if(!categoryNames.isEmpty()){
				List<FieloCMS__Category__c> categories = [SELECT Id, Name FROM FieloCMS__Category__c WHERE Name in : categoryNames];
				Map<String,Id> categoriesByName = new Map<String,Id>();

				for(FieloCMS__Category__c category : categories){
					categoriesByName.put(category.Name, category.Id);
				}

				Map<Id,FieloCMS__Category__c> newCategoriesMap = new Map<Id,FieloCMS__Category__c>();
				for(FieloELR__Module__c module : modulesMap.values()){
					if(categoriesByName.containsKey(module.Name)){
						module.ContentCategory__c = categoriesByName.get(module.Name);
					}else if(module.FieloELR__Course__r.ContentCategory__c == null){
						throw new FieloPLT.FieloException('The related course must have content enabled.');
					}else{
						newCategoriesMap.put(module.Id, new FieloCMS__Category__c(Name = module.Name, FieloCMS__Category__c = module.FieloELR__Course__r.ContentCategory__c));
					}
				}

				if(!newCategoriesMap.isEmpty()){
					insert newCategoriesMap.values();
					for(Id moduleId : newCategoriesMap.keySet()){
						modulesMap.get(moduleId).ContentCategory__c = newCategoriesMap.get(moduleId).Id;
					}
				}
				update modulesMap.values();
			}
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}
	}

}