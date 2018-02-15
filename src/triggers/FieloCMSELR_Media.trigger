trigger FieloCMSELR_Media on FieloCMS__Media__c (before update) {
	FieloCMSELR_Media.onBeforeUpdate(Trigger.new, Trigger.oldMap);
}