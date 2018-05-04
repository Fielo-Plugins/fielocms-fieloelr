trigger FieloCMSELR_Posts on FieloCMS__Post__c (before update) {
	FieloCMSELR_Posts.onBeforeUpdate(Trigger.new, Trigger.oldMap);
}