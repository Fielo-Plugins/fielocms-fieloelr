trigger FieloCMSELR_Modules on FieloELR__Module__c (before update) {
	FieloCMSELR_Modules.onBeforeUpdate(Trigger.new, Trigger.oldMap);
}