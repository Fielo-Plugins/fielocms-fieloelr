global class CourseAPI implements FieloCMS.DataInterface, FieloCMS.ViewSubComponentInterface{
	global Map<Id, Object> getBulkData(List<FieloCMS__Component__c> components){
        Map<Id,Object> newMapData = new Map<Id,Object>();
        Id memberId = MemberService.getCurrentMemberId();
        //Prepare all the queries
        for(FieloCMS__Component__c c : components){
            if(c.FieloCMS__Limit__c == null)
                c.FieloCMS__Limit__c = 5;

            if(c.FieloCMS__ComponentLibrary__r.Name == 'Courses'){
                system.debug('Fieldset');
                system.debug(OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c));
                FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
                List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                    OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c),
                    null,
                    null,
                    null,
                    member.FieloPLT__Program__c,
                    member.Id,
                    true,
                    true,
                    false,
                    Integer.valueof(c.FieloCMS__Limit__c),
                    0,
                    'LastModifiedDate',
                    ''
                );

                newMapData.put(c.Id, (List<Object>)courses);
            }
            if(c.FieloCMS__ComponentLibrary__r.Name == 'Course Detail'){
                String recordId = ApexPages.CurrentPage().getParameters().get( c.FieloCMS__DetailParameter__c );
                FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
                
                List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                    OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c),
                    null,
                    null,
                    new Set<Id>{recordId},
                    member.FieloPLT__Program__c,
                    member.Id,
                    true,
                    true,
                    false,
                    Integer.valueof(c.FieloCMS__Limit__c),
                    0,
                    'LastModifiedDate',
                    ''
                );
                system.debug('courses');
                system.debug(courses);
                newMapData.put(c.Id, courses[0]);
            }

            if(c.FieloCMS__ComponentLibrary__r.Name == 'Modules'){
                String recordId = ApexPages.CurrentPage().getParameters().get( c.FieloCMS__DetailParameter__c );
                FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
                
                List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                    new Set<String>{'Id','Name'},
                    null,
                    OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c),
                    new Set<Id>{recordId},
                    member.FieloPLT__Program__c,
                    member.Id,
                    true,
                    true,
                    false,
                    Integer.valueof(c.FieloCMS__Limit__c),
                    0,
                    'LastModifiedDate',
                    ''
                );
                system.debug('courses');
                system.debug(courses);
                newMapData.put(c.Id, (List<Object>) courses[0].FieloELR__Modules__r);
            }
        }
        return newMapData;
    }

    global List<sObject> getData(FieloCMS__Component__c component, Integer pageNumber, String orderBy, String filters){
        if(component.FieloCMS__Limit__c == null)
            component.FieloCMS__Limit__c = 5;

        //Member Id
        Id memberId = MemberService.getCurrentMemberId();

        //Member Data
        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];

        //Filter
        Id recordId;
        Map<String, String> filtersMap = (Map<String, String>)JSON.deserialize(filters, Map<string,String>.class);
        if (!filtersMap.isEmpty()){
            if (filtersMap.containsKey('id')) {
                recordId = filtersMap.get('id');
            }
        }
        //Calculate the offset from the Page Number
        Integer offset = Integer.valueOf(component.FieloCMS__Limit__c * (pageNumber - 1));

        if (component.FieloCMS__ComponentLibrary__r.Name == 'Courses') {
            List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                OrganizationUtil.getFieldSet(component.FieloCMS__FieldSet__c),
                null,
                null,
                null,
                member.FieloPLT__Program__c,
                member.Id,
                true,
                true,
                true,
                Integer.valueof(component.FieloCMS__Limit__c),
                offset,
                'LastModifiedDate',
                ''
            );
            return (List<sObject>) courses;
        }
        if(component.FieloCMS__ComponentLibrary__r.Name == 'Course Detail'){
            List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                OrganizationUtil.getFieldSet(component.FieloCMS__FieldSet__c),
                null,
                null,
                new Set<Id>{recordId},
                member.FieloPLT__Program__c,
                member.Id,
                true,
                true,
                false,
                Integer.valueof(component.FieloCMS__Limit__c),
                0,
                'LastModifiedDate',
                ''
            );
            return (List<sObject>) courses;
        }
        if(component.FieloCMS__ComponentLibrary__r.Name == 'Modules'){
            List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                new Set<String>{'Id','Name'},
                null,
                OrganizationUtil.getFieldSet(component.FieloCMS__FieldSet__c),
                new Set<Id>{recordId},
                member.FieloPLT__Program__c,
                member.Id,
                true,
                true,
                false,
                Integer.valueof(component.FieloCMS__Limit__c),
                0,
                'LastModifiedDate',
                ''
            );
            return (List<sObject>) courses[0].FieloELR__Modules__r;
        }
        return null;
    }

    global ApexPages.Component getSubComponent(FieloCMS.Field field, SObject record){
        Component.Widget1 progress = new Component.Widget1();
        if(record != null){
            progress.record = record;
        }else{
            progress.expressions.record = '{!record}';
        }
        progress.field = field;
        return progress;
    }

    @RemoteAction
    public static List<SObject> getCourseStatus(List<String> courseIds) {
        Id memberId = MemberService.getCurrentMemberId();
        List<FieloELR__CourseStatus__c> courseStatus = FieloELR.CourseService.getCourseStatus(
            new Set<String>{'FieloELR__Progress__c','FieloELR__Course__c'},
            null,
            new Set<Id>((List<Id>)courseIds),
            memberId,
            100,
            0,
            'FieloELR__Course__r.FieloELR__Order__c'
        );
        return courseStatus;
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
    public static Map<String,String> getModuleActions(List<String> moduleIds){
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
                true,
                true,
                100,
                0,
                'LastModifiedDate',
                ''
            );
        } catch(Exception e) {
            System.debug('error: ' + e);
        }

        Map<String,String> moduleActions = new Map<String,String>();

        if (coursesMap == null) {
            for (FieloELR__Module__c module: modules) {
                moduleActions.put(module.Id,'Take');
            }
        } else {
            for (FieloELR.CourseService.CourseWrapper courseMap :coursesMap) {
                if (courseMap.course.FieloELR__SubscriptionMode__c == 'Manual' && courseMap.courseStatus == null) {
                    for (FieloELR.CourseService.ModuleWrapper moduleWrapper: courseMap.modules){
                        moduleActions.put(moduleWrapper.module.Id,'View');
                    }
                } else {
                    for (FieloELR.CourseService.ModuleWrapper moduleWrapper: courseMap.modules){
                        if (moduleWrapper.moduleResponses != null) {
                            if (moduleWrapper.moduleResponses == null) {
                                moduleActions.put(moduleWrapper.module.Id,'Take');
                            } else if(moduleWrapper.moduleResponses.isEmpty()){
                                moduleActions.put(moduleWrapper.module.Id,'Take');
                            } else if(!moduleWrapper.isApproved && moduleWrapper.numberOfAttempts <= moduleWrapper.module.FieloELR__AttemptsAllowed__c) {
                                moduleActions.put(moduleWrapper.module.Id,'Retake');
                            } else if(moduleWrapper.isApproved && moduleWrapper.numberOfAttempts <= moduleWrapper.module.FieloELR__AttemptsAllowed__c) {
                                moduleActions.put(moduleWrapper.module.Id,'View,Retake');
                            } else {
                                moduleActions.put(moduleWrapper.module.Id,'View');
                            }
                        } else {
                            moduleActions.put(moduleWrapper.module.Id,'Take');
                        }
                    }
                }
            }
        }
        return moduleActions;
    }

    @RemoteAction
    public static sObject joinCourse(String courseId) {
        Id memberId = MemberService.getCurrentMemberId();
        FieloELR__CourseStatus__c cs = new FieloELR__CourseStatus__c(FieloELR__Course__c = courseId,FieloELR__Member__c = memberId);
        insert cs; 
        return (sObject) cs;
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

    global class CourseAction implements FieloCMS.ViewSubComponentInterface {
        global ApexPages.Component getSubComponent(FieloCMS.Field field, SObject record){
            system.debug('Course Action');
            system.debug(field);
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
    }    
}