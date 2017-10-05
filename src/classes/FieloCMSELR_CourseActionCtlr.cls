global class FieloCMSELR_CourseActionCtlr implements FieloCMS.ViewSubComponentInterface{
	public ApexPages.Component getSubComponent(FieloCMS.Field field, SObject record){
        Component.FieloCMSELR_CourseAction action = new Component.FieloCMSELR_CourseAction();
        if(record != null){
            action.record = record;
        }else{
            action.expressions.record = '{!record}';
        }
        action.expressions.config = '{!config}';
        action.field = field;
        return action;
    }

    @RemoteAction
    global static Map<String,Object> getCourseActions(Id componentId, List<String> courseIds) {
        FieloCMS__Component__c component = [Select Id, FieloCMSELR_CustomDetailParameter__c, FieloCMSPLT_RedirectPage__c, FieloCMS__ComponentLibrary__r.FieloCMS__sObject__c, FieloCMSELR_FilterByDependency__c, FieloCMSELR_FilterBySegment__c, FieloCMSELR_FilterByNotTaken__c From FieloCMS__Component__c Where Id= :componentId];
        
        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
        List<FieloELR.CourseService.CourseWrapper> coursesWrapper = FieloELR.CourseService.getCoursesMap(
            new Set<String>{'Id','FieloELR__SubscriptionMode__c','FieloELR__Status__c'},
            new Set<String>{'Id','Name'},
            new Set<String>{'Id','Name'},
            null,
            new Set<Id>((List<Id>)courseIds),
            member.FieloPLT__Program__c,
            member.Id,
            false,
            component.FieloCMSELR_FilterBySegment__c,
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
        Map<Id,FieloELR__CourseStatus__c> courseStatusMap = new Map<Id,FieloELR__CourseStatus__c>(courseStatus);
        Map<Id,Id> joinedCourses = new Map<Id,Id>();
        for(FieloELR__CourseStatus__c cs: courseStatus) {
            joinedCourses.put(cs.FieloELR__Course__c, cs.Id);
        }

        Map<String,Object> courseActionMap = new Map<String,Object>();
        String redirectPage;
        FieloELR__Course__c course;
        Boolean allowedForDependency;
        for(FieloELR.CourseService.CourseWrapper cw: coursesWrapper) {
            course = cw.course;
            allowedForDependency = cw.allowedForDependency;
            // Once it can be null, it must be set to boolean to avoid nullpointer.
            allowedForDependency = allowedForDependency != null ?
                allowedForDependency :
                true;
            redirectPage = '/FieloCMS__Page?pageId=' + component.FieloCMSPLT_RedirectPage__c + 
                '&' + component.FieloCMSELR_CustomDetailParameter__c + '=' + course.Id;
            if (!joinedCourses.containsKey(course.Id)) {
                if (allowedForDependency) {
                    courseActionMap.put(course.Id,
                        (Object) new Map<String,Object>{
                            'Action' => course.FieloELR__SubscriptionMode__c =='Manual' ? 'Join' : 'Hide',
                            'Page' => redirectPage
                        }
                    );
                } else {
                    courseActionMap.put(course.Id,
                        (Object) new Map<String,Object>{
                            'Action' => 'Hide',
                            'Page' => redirectPage
                        }
                    );
                }
            } else {
                courseActionMap.put(course.Id,
                    (Object) new Map<String,Object>{
                        'Action' => 'Hide',
                        'Page' => redirectPage
                    }
                );
            }
        }
        return courseActionMap;
    }

    @RemoteAction
    global static sObject joinCourse(String courseId) {
        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
        FieloELR__CourseStatus__c cs = new FieloELR__CourseStatus__c(FieloELR__Course__c = courseId,FieloELR__Member__c = memberId);
        insert cs; 
        return (sObject) cs;
    }

    public sObject cRecord{set;get;}
    public sObject cConfig{set;get;}
    public FieloCMS.Field cField{set;get;}

    public String action {get{
        Decimal progress = (Decimal) cRecord.get('FieloELR__Progress__c');
        if ( progress != null ) {
            if (progress >= 0 && progress < 100 ) {
                return 'Continue';
            } else {
                return 'View';
            }
        } else {
            return 'View';
        }
    }
        set;
    }

    public String href{get{
        if (href==null) {
            href = '/FieloCMS__Page?pageId=' +
                (String)cField.attributes.get('PageId') +
                '&id=' +
                (String)cRecord.get((String)cField.attributes.get('fieldName'));
        }
        return href;
    }
        set;
    }
}