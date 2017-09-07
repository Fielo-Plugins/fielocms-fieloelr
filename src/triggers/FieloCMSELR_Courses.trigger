trigger FieloCMSELR_Courses on FieloELR__Course__c (before update) {
	FieloCMSELR_Courses.onBeforeUpdate(Trigger.new, Trigger.oldMap);
}