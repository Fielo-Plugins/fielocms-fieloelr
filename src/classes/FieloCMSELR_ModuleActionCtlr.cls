global class FieloCMSELR_ModuleActionCtlr implements FieloCMS.ViewSubComponentInterface{
	public ApexPages.Component getSubComponent(FieloCMS.Field field, SObject record){
        Component.FieloCMSELR_ModuleAction action = new Component.FieloCMSELR_ModuleAction();
        if(record != null){
            action.record = record;
        }else{
            action.expressions.record = '{!record}';
        }
        action.field = field;
        if (field.attributes.containsKey('takeRedirectPage')) {
            action.takePageField = field.attributes.get('takeRedirectPage') instanceof Id ?
                'pageId' :
                'p';
        }
        if (field.attributes.containsKey('viewRedirectPage')) {
            action.viewPageField = field.attributes.get('viewRedirectPage') instanceof Id ?
                'pageId' :
                'p';
        }
        return action;
    }

    @RemoteAction
    global static Map<String,Object> getModuleActions(Id componentId, List<String> moduleIds){
    	FieloCMS__Component__c component = [SELECT FieloCMS__DetailParameter__c, FieloCMSPLT_RedirectPage__c FROM FieloCMS__Component__c WHERE Id =: componentId];
        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
        List<FieloELR__Module__c> modules = [SELECT FieloELR__Course__r.Id, FieloELR__Course__r.FieloELR__SubscriptionMode__c, FieloELR__Course__r.FieloELR__Status__c, FieloELR__IsActive__c From FieloELR__Module__c Where Id in :moduleIds];
        Set<Id> courseIds = new Set<Id>();

        for(FieloELR__Module__c module: modules) {
            courseIds.add(module.FieloELR__Course__r.Id);
        }

        List<FieloELR.CourseService.CourseWrapper> coursesMap;
        
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
    

        Map<String,Object> moduleActions = new Map<String,Object>();

        if (coursesMap == null) {
            for (FieloELR__Module__c module: modules) {
                if (module.FieloELR__Course__r.FieloELR__SubscriptionMode__c == 'Manual') {
                    moduleActions.put(module.Id,(Object) new Map<String,Object>{'Actions' => (Object) new List<String>{'Hide'}});
                } else {
                    if (module.FieloELR__Course__r.FieloELR__Status__c != 'Active') {
                        moduleActions.put(module.Id,
                            (Object) new Map<String,Object>{
                                'Actions' => (Object) new List<String>{'Hide'}
                            }
                        );
                    } else {
                        moduleActions.put(module.Id,
                            (Object) new Map<String,Object>{
                                'Actions' => (Object) new List<String>{ module.FieloELR__IsActive__c ? 'Take' : 'Hide'}
                            }
                        );
                    }
                }
            }
        } else {
            Boolean allowedForDependency;
            for (FieloELR.CourseService.CourseWrapper courseMap :coursesMap) {
                allowedForDependency = courseMap.allowedForDependency;
                // Once it can be null, it must be set to boolean to avoid nullpointer.
                allowedForDependency = allowedForDependency != null ?
                    allowedForDependency :
                    true;
                if (!allowedForDependency) {
                    for (FieloELR.CourseService.ModuleWrapper moduleWrapper: courseMap.modules){
                        moduleActions.put(moduleWrapper.module.Id,
                            (Object) new Map<String,Object>{
                                'Actions' => (Object) new List<String>{'Hide'}
                            }
                        );
                    }
                } else if (courseMap.course.FieloELR__Status__c != 'Active') {
                    for (FieloELR.CourseService.ModuleWrapper moduleWrapper: courseMap.modules){
                        if (moduleWrapper.moduleResponses.isEmpty()) {
                                moduleActions.put(moduleWrapper.module.Id,(Object) new Map<String,Object>{'Actions' => (Object) new List<String>{'Hide'}});
                            } else {
                                moduleActions.put(moduleWrapper.module.Id,
                                    (Object) new Map<String,Object>{
                                        'Actions' => (Object) new List<String>{'View'},
                                        'ModuleResponseId' => (Object) moduleWrapper.moduleResponses.get(moduleWrapper.moduleResponses.size()-1).Id,
                                        'PageId' => component.FieloCMSPLT_RedirectPage__c,
                                        'Approved' => moduleWrapper.isApproved
                                    }
                                );
                            }
                        
                    }
                } else {
                    if (courseMap.course.FieloELR__SubscriptionMode__c == 'Manual' && courseMap.courseStatus == null) {
                        for (FieloELR.CourseService.ModuleWrapper moduleWrapper: courseMap.modules){
                            moduleActions.put(moduleWrapper.module.Id,
                                (Object) new Map<String,Object>{
                                    'Actions' => (Object) new List<String>{'Hide'}
                                }
                            );
                        }
                    } else {
                        for (FieloELR.CourseService.ModuleWrapper moduleWrapper: courseMap.modules){
                            if (moduleWrapper.moduleResponses != null) {
                                if(moduleWrapper.moduleResponses.isEmpty()){
                                    if (moduleWrapper.allowedForDependency) {
                                        moduleActions.put(moduleWrapper.module.Id,
                                            (Object) new Map<String,Object>{
                                                'Actions' => (Object) new List<String>{ moduleWrapper.module.FieloELR__IsActive__c ? 'Take' : 'Hide'}
                                            }
                                        );
                                    } else {
                                        moduleActions.put(moduleWrapper.module.Id,(Object) new Map<String,Object>{'Actions' => (Object) new List<String>{'Hide'}});
                                    }
                                } else if(moduleWrapper.numberOfAttempts < moduleWrapper.module.FieloELR__AttemptsAllowed__c || moduleWrapper.module.FieloELR__AttemptsAllowed__c == null){
                                    moduleActions.put(moduleWrapper.module.Id,
                                        (Object) new Map<String,Object>{
                                            'Actions' => (Object) new List<String>{'View','Retake'},
                                            'ModuleResponseId' => (Object) moduleWrapper.moduleResponses.get(moduleWrapper.moduleResponses.size()-1).Id,
                                            'PageId' => component.FieloCMSPLT_RedirectPage__c,
                                            'Approved' => moduleWrapper.isApproved
                                        }
                                    );
                                } else {
                                    moduleActions.put(moduleWrapper.module.Id,
                                        (Object) new Map<String,Object>{
                                            'Actions' => (Object) new List<String>{'View'},
                                            'ModuleResponseId' => (Object) moduleWrapper.moduleResponses.get(moduleWrapper.moduleResponses.size()-1).Id,
                                            'PageId' => component.FieloCMSPLT_RedirectPage__c,
                                            'Approved' => moduleWrapper.isApproved
                                        }
                                    );
                                }
                            } else {
                                if (moduleWrapper.allowedForDependency) {
                                    moduleActions.put(moduleWrapper.module.Id,
                                        (Object) new Map<String,Object>{
                                            'Actions' => (Object) new List<String>{ moduleWrapper.module.FieloELR__IsActive__c ? 'Take' : 'Hide'}
                                        }
                                    );
                                } else {
                                    moduleActions.put(moduleWrapper.module.Id,
                                        (Object) new Map<String,Object>{
                                            'Actions' => (Object) new List<String>{'Hide'}
                                        }
                                    );
                                }
                            }
                        }
                    }
                }
            }
        }
        return moduleActions;
    }

    @RemoteAction
    global static FieloELR.ModuleService.ModuleWrapper takeModule(String moduleId) {
        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
        FieloELR.ModuleService.ModuleWrapper moduleWrapper = FieloELR.ModuleService.takeModule(
            moduleId,
            member.Id,
            new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c','FieloCMSELR_ContentCategory__c'},
            new Set<String> {'FieloELR__QuestionText__c'},
            new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c'}
        );
        return moduleWrapper;
    }

    public String pathPrefix { get{
        if (pathPrefix==null) {
            if (!Test.isRunningTest()) {
                pathPrefix = Site.getPathPrefix();
            } else {
                pathPrefix = '';
            }
        }
        return pathPrefix;
    }
        set;
    }
}