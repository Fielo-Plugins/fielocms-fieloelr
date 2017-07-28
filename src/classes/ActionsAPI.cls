global class ActionsAPI implements FieloCMS.ViewSubComponentInterface{
	global ApexPages.Component getSubComponent(FieloCMS.Field field, SObject record){
		system.debug('field');
		system.debug(field);
		system.debug('record');
		system.debug(record);
        Component.Widget2 action = new Component.Widget2();
        if(record != null){
            action.record = record;
        }else{
            action.expressions.record = '{!record}';
        }
        action.field = field;
        return action;
    }

    @RemoteAction
    public static Map<String,String> getCourseActions(List<String> courseIds) {
        Id memberId = MemberService.getCurrentMemberId();
        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
        List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
            new Set<String>{'Id','FieloELR__SubscriptionMode__c'},
            null,
            null,
            new Set<Id>((List<Id>)courseIds),
            member.FieloPLT__Program__c,
            member.Id,
            true,
            true,
            false,
            null,
            0,
            'LastModifiedDate',
            ''
        );
        List<FieloELR__CourseStatus__c> courseStatus = FieloELR.CourseService.getCourseStatus(
            new Set<String>{'Id','FieloELR__Progress__c','FieloELR__Course__c'},
            null,
            new Set<Id>((List<Id>)courseIds),
            memberId,
            100,
            0,
            'FieloELR__Course__r.FieloELR__Order__c'
        );
        Map<Id,FieloELR__Course__c> courseMap = new Map<Id,FieloELR__Course__c>(courses);
        Map<Id,FieloELR__CourseStatus__c> courseStatusMap = new Map<Id,FieloELR__CourseStatus__c>(courseStatus);
        Map<Id,Id> joinedCourses = new Map<Id,Id>();
        for(FieloELR__CourseStatus__c cs: courseStatus) {
            joinedCourses.put(cs.FieloELR__Course__c, cs.Id);
        }

        Map<String,String> courseActionMap = new Map<String,String>();

        for(FieloELR__Course__c course: courses) {
            if (!joinedCourses.containsKey(course.Id)) {
                if (course.FieloELR__SubscriptionMode__c =='Manual') {
                    courseActionMap.put(course.Id,'Join');
                } else {
                    courseActionMap.put(course.Id,'View');
                }
            } else {
                if(courseStatusMap.get(joinedCourses.get(course.Id)).FieloELR__Progress__c == null) {
                    courseActionMap.put(course.Id,'Continue');
                } else {
                    if (courseStatusMap.get(joinedCourses.get(course.Id)).FieloELR__Progress__c >= 0 && 
                        courseStatusMap.get(joinedCourses.get(course.Id)).FieloELR__Progress__c < 100) {
                        courseActionMap.put(course.Id,'Continue');
                    } else {
                        courseActionMap.put(course.Id,'View');
                    }
                }
            }
        }
        return courseActionMap;
    }

    @RemoteAction
    public static sObject joinCourse(String courseId) {
        Id memberId = MemberService.getCurrentMemberId();
        FieloELR__CourseStatus__c cs = new FieloELR__CourseStatus__c(FieloELR__Course__c = courseId,FieloELR__Member__c = memberId);
        insert cs; 
        return (sObject) cs;
    }

    @RemoteAction
    public static Map<String,Object> getModuleActions(Id componentId, List<String> moduleIds){
    	FieloCMS__Component__c component = [SELECT FieloCMS__DetailParameter__c, RedirectPage__c FROM FieloCMS__Component__c WHERE Id =: componentId];
        Id memberId = MemberService.getCurrentMemberId();
        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
        List<FieloELR__Module__c> modules = [SELECT FieloELR__Course__r.Id From FieloELR__Module__c Where Id in :moduleIds];
        Set<Id> courseIds = new Set<Id>();

        for(FieloELR__Module__c module: modules) {
            courseIds.add(module.FieloELR__Course__r.Id);
        }

        List<FieloELR.CourseService.CourseWrapper> coursesMap;
        try {
            coursesMap = FieloELR.CourseService.getCoursesMap(
                new Set<String>{'Id','FieloELR__SubscriptionMode__c'},
                null,
                new Set<String>{'Id', 'FieloELR__AttemptsAllowed__c'},
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
        } catch(Exception e) {
            System.debug('error: ' + e);
        }

        Map<String,Object> moduleActions = new Map<String,Object>();

        if (coursesMap == null) {
            for (FieloELR__Module__c module: modules) {
                moduleActions.put(module.Id,(Object) new Map<String,Object>{'Actions' => (Object) new List<String>{'Take'}});
            }
        } else {
            for (FieloELR.CourseService.CourseWrapper courseMap :coursesMap) {
                if (courseMap.course.FieloELR__SubscriptionMode__c == 'Manual' && courseMap.courseStatus == null) {
                    for (FieloELR.CourseService.ModuleWrapper moduleWrapper: courseMap.modules){
                        moduleActions.put(moduleWrapper.module.Id,(Object) new Map<String,Object>{'Actions' => (Object) new List<String>{'View'}});
                    }
                } else {
                    for (FieloELR.CourseService.ModuleWrapper moduleWrapper: courseMap.modules){
                        system.debug('moduleWrapper');
                        system.debug(moduleWrapper);
                        if (moduleWrapper.moduleResponses != null) {
                            if(moduleWrapper.moduleResponses.isEmpty()){
                                if (moduleWrapper.allowedForDependency) {
                                    moduleActions.put(moduleWrapper.module.Id,(Object) new Map<String,Object>{'Actions' => (Object) new List<String>{'Take'}});
                                } else {
                                    moduleActions.put(moduleWrapper.module.Id,(Object) new Map<String,Object>{'Actions' => (Object) new List<String>{'Take','Hide'}});
                                }
                            } else if(!moduleWrapper.isApproved && ( moduleWrapper.numberOfAttempts < moduleWrapper.module.FieloELR__AttemptsAllowed__c || moduleWrapper.module.FieloELR__AttemptsAllowed__c == null)) {
                                moduleActions.put(moduleWrapper.module.Id,(Object) new Map<String,Object>{'Actions' => (Object) new List<String>{'Retake'}, 'ModuleResponseId' => (Object) moduleWrapper.moduleResponses.get(moduleWrapper.moduleResponses.size()-1).Id, 'PageId' => component.RedirectPage__c});
                            } else if(moduleWrapper.isApproved && ( moduleWrapper.numberOfAttempts < moduleWrapper.module.FieloELR__AttemptsAllowed__c || moduleWrapper.module.FieloELR__AttemptsAllowed__c == null) ){
                                moduleActions.put(moduleWrapper.module.Id,(Object) new Map<String,Object>{'Actions' => (Object) new List<String>{'View','Retake'}, 'ModuleResponseId' => (Object) moduleWrapper.moduleResponses.get(moduleWrapper.moduleResponses.size()-1).Id, 'PageId' => component.RedirectPage__c});
                            } else {
                                moduleActions.put(moduleWrapper.module.Id,(Object) new Map<String,Object>{'Actions' => (Object) new List<String>{'View'}, 'PageId' => component.RedirectPage__c});
                            }
                        } else {
                            if (moduleWrapper.allowedForDependency) {
                                moduleActions.put(moduleWrapper.module.Id,(Object) new Map<String,Object>{'Actions' => (Object) new List<String>{'Take'}});
                            } else {
                                moduleActions.put(moduleWrapper.module.Id,(Object) new Map<String,Object>{'Actions' => (Object) new List<String>{'Take','Hide'}});
                            }
                        }
                    }
                }
            }
        }
        return moduleActions;
    }

    @RemoteAction
    public static FieloELR.ModuleService.ModuleWrapper takeModule(String moduleId) {
        Id memberId = MemberService.getCurrentMemberId();
        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
        FieloELR.ModuleService.ModuleWrapper moduleWrapper = FieloELR.ModuleService.takeModule(
            moduleId,
            member.Id,
            new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
            new Set<String> {'FieloELR__QuestionText__c'},
            new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c'}
        );
        return moduleWrapper;
    }
}