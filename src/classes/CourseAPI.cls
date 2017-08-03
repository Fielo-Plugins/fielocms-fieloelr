global class CourseAPI implements FieloCMS.DataInterface, FieloCMS.ViewSubComponentInterface{
    global Map<Id, Object> getBulkData(List<FieloCMS__Component__c> components){
        Map<Id,Object> newMapData = new Map<Id,Object>();
        Id memberId = MemberService.getCurrentMemberId();
        //Prepare all the queries
        for(FieloCMS__Component__c c : components){
            if(c.FieloCMS__Limit__c == null)
                c.FieloCMS__Limit__c = 5;

            if(c.FieloCMS__ComponentLibrary__r.Name == 'Courses'){
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
                    'FieloELR__Order__c',
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
                newMapData.put(c.Id, courses[0]);
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

    public FieloCMS.Field cField {get; set;}
    public sObject cRecord {get;set;}

    public Decimal progress {get{
        if (cField.attributes.containsKey('useFieldValue')) {
            if (cField.attributes.get('useFieldValue')!=null) {
                if ((String)cField.attributes.get('useFieldValue')=='true') {
                    return (Decimal) cRecord.get((String)cField.attributes.get('fieldName'));
                } else {
                    return 1;
                }
            } else {
                return 1;
            }
        } else {
            return 1;
        }
    }
        set;
    }

    public String progressLabel {get{
        if (cField.attributes.containsKey('useFieldValue')) {
            if (cField.attributes.get('useFieldValue')!=null) {
                if ((String)cField.attributes.get('useFieldValue')=='true') {
                    return '&nbsp;<b>' + String.valueOf(cRecord.get((String)cField.attributes.get('fieldName'))) + '%</b>';
                } else {
                    return '';
                }
            } else {
                return '';
            }
        } else {
            return '';
        }
    }
        set;
    }
}