global class FieloCMSELR_ModuleStatusCtrl implements FieloCMS.ViewSubComponentInterface {
	public ApexPages.Component getSubComponent(FieloCMS.Field field, SObject record){
        Component.FieloCMSELR_ModuleStatus moduleStatus = new Component.FieloCMSELR_ModuleStatus();
        if(record != null){
            moduleStatus.record = record;
        }else{
            moduleStatus.expressions.record = '{!record}';
        }
        moduleStatus.field = field;
        return moduleStatus;
    }

    @RemoteAction
    global static Map<String,Object> getModuleStatus(Id componentId, List<String> moduleIds){
        FieloCMS__Component__c component = [SELECT FieloCMS__DetailParameter__c, FieloCMSPLT_RedirectPage__c FROM FieloCMS__Component__c WHERE Id =: componentId];
        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
        List<FieloELR__Module__c> modules = [SELECT FieloELR__Course__r.Id, FieloELR__Course__r.FieloELR__SubscriptionMode__c, FieloELR__Course__r.FieloELR__Status__c, FieloELR__IsActive__c From FieloELR__Module__c Where Id in :moduleIds];
        Set<Id> courseIds = new Set<Id>();

        for(FieloELR__Module__c module: modules) {
            courseIds.add(module.FieloELR__Course__r.Id);
        }

        List<FieloELR.CourseService.CourseWrapper> coursesMap;
        
        try {
            coursesMap = FieloELR.CourseService.getCoursesMap(
                new Set<String>{'Id','FieloELR__SubscriptionMode__c','FieloELR__Status__c'},
                new Set<String>{'Id','Name'},
                new Set<String>{'Id', 'FieloELR__AttemptsAllowed__c','FieloELR__IsActive__c'},
                null,
                courseIds,
                member.FieloPLT__Program__c,
                member.Id,
                false,
                true,
                100,
                0,
                'LastModifiedDate',
                ''
            );
        } catch (Exception e) {
            System.debug('error' + e);
        }
    

        Map<String,Object> moduleStatus = new Map<String,Object>();

        Set<String> moduleIdSet = new Set<String>(moduleIds);

        if (coursesMap == null) {
            for (FieloELR__Module__c module: modules) {
                moduleStatus.put(module.Id, (Object) 'Not Joined');
            }
        } else {
            for (FieloELR.CourseService.CourseWrapper courseMap :coursesMap) {
                for (FieloELR.CourseService.ModuleWrapper moduleWrapper: courseMap.modules){
                    if (moduleIdSet.contains(moduleWrapper.module.Id)) {
                        if (moduleWrapper.moduleResponses == null) {
                            moduleStatus.put(moduleWrapper.module.Id, (Object) 'Not Taken');
                        } else {
                            if (moduleWrapper.moduleResponses.isEmpty()) {
                                moduleStatus.put(moduleWrapper.module.Id, (Object) 'Not Taken');
                            } else {
                                if (moduleWrapper.isApproved == null) {
                                    moduleStatus.put(moduleWrapper.module.Id, (Object) 'Not Taken');
                                } else {
                                    moduleStatus.put(moduleWrapper.module.Id, (Object) (moduleWrapper.isApproved ? 'Passed' : 'Not Passed') );
                                }
                            }
                        }
                    }
                }
            }
        }
        return moduleStatus;
    }

    public FieloCMS.Field cField {get; set;}
    public sObject cRecord {get;set;}
}