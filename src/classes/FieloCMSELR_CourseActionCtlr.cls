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
    global static Map<String,String> getCourseActions(Id componentId, List<String> courseIds) {
        FieloCMS__Component__c component = [Select Id, FieloCMS__ComponentLibrary__r.FieloCMS__sObject__c From FieloCMS__Component__c Where Id= :componentId];
        
        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
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
}