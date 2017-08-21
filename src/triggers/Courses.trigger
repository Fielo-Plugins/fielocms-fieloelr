trigger Courses on FieloELR__Course__c (before update) {
	Courses.onBeforeUpdate(Trigger.new, Trigger.oldMap);
}