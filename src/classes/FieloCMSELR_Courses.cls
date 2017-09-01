public with sharing class FieloCMSELR_Courses {
	
	public static void onBeforeUpdate(List<FieloELR__Course__c> courses, Map<Id,FieloELR__Course__c> existingRecords){
		List<FieloCMS__Category__c> categories = new List<FieloCMS__Category__c>();
		for(FieloELR__Course__c course : courses){
			if(course.Name != existingRecords.get(course.Id).Name && course.FieloCMSELR_ContentCategory__c != null){
				categories.add(new FieloCMS__Category__c(Id = course.FieloCMSELR_ContentCategory__c, Name = course.Name));
			}
		}

		update categories;
	}

}