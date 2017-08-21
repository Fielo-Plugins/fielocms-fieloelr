public with sharing class CourseService {
	
	public static void relateToCategories(Set<Id> courseIds){
		SavePoint sp = Database.setSavePoint();
		try{
			Set<String> categoryNames = new Set<String>();
			Map<Id,FieloELR__Course__c> coursesMap = new Map<Id,FieloELR__Course__c>([SELECT Id FROM FieloELR__Course__c WHERE ContentCategory__c = null AND Id in : courseIds]);
			for(FieloELR__Course__c course : coursesMap.values()){
				categoryNames.add(course.Name);
			}

			if(!categoryNames.isEmpty()){
				List<FieloCMS__Category__c> categories = [SELECT Id, Name FROM FieloCMS__Category__c WHERE Name in : categoryNames];
				Map<String,Id> categoriesByName = new Map<String,Id>();

				for(FieloCMS__Category__c category : categories){
					categoriesByName.put(category.Name, category.Id);
				}

				Map<Id,FieloCMS__Category__c> newCategoriesMap = new Map<Id,FieloCMS__Category__c>();
				for(FieloELR__Course__c course : coursesMap.values()){
					if(categoriesByName.containsKey(course.Name)){
						course.ContentCategory__c = categoriesByName.get(course.Name);
					}else{
						newCategoriesMap.put(course.Id, new FieloCMS__Category__c(Name = course.Name, FieloCMS__Category__c = getELearningCategory()));
					}
				}

				if(!newCategoriesMap.isEmpty()){
					insert newCategoriesMap.values();
					for(Id courseId : newCategoriesMap.keySet()){
						coursesMap.get(courseId).ContentCategory__c = newCategoriesMap.get(courseId).Id;
					}
				}
				update coursesMap.values();
			}
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}
	}

	private static FieloCMS__Category__c parentCategory;
	private static Id getELearningCategory(){
		if(parentCategory == null){
			try{
				parentCategory = [SELECT Id FROM FieloCMS__Category__c WHERE Name = 'E-Learning'];
			}catch(Exception e){
				parentCategory = new FieloCMS__Category__c(Name = 'E-Learning');
				insert parentCategory;
			}
		}
		return parentCategory.Id;
	}

}