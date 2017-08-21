trigger Modules on FieloELR__Module__c (before update) {
	Modules.onBeforeUpdate(Trigger.new, Trigger.oldMap);
}