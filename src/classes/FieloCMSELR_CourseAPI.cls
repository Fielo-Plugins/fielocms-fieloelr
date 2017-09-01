public class FieloCMSELR_CourseAPI implements FieloCMS.DataInterface{
    
    private class FilterWrapper{
        public String field;
        public String operator;
        public String value;
        public String andOrOperator;
        public SubQueryFilter subQueryFilter;

        public FilterWrapper(String field, String operator, String value){
            this.field = field;
            this.operator = operator;
            this.value = value;
        }
    }

    private class SubQueryFilter{
        public String field;
        public String objectName;
        public List<FilterWrapper> filters;

        public SubQueryFilter(String field, String objectName, List<FilterWrapper> filters){
            this.field = field;
            this.objectName = objectName;
            this.filters = filters;
        }
    }

    public Map<Id, Object> getBulkData(List<FieloCMS__Component__c> components){
        Map<Id,Object> newMapData = new Map<Id,Object>();
        Id memberId = MemberService.getCurrentMemberId();
        //Prepare all the queries
        for(FieloCMS__Component__c c : components){
            if(c.FieloCMS__Limit__c == null)
                c.FieloCMS__Limit__c = 5;

            if(c.FieloCMS__ComponentLibrary__r.Name == 'Courses'){
                FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
                
                List<FilterWrapper> dynamicFilters = new List<FilterWrapper>();
                if(c.FieloCMS__Category__c != null){
                    dynamicFilters.add(new FilterWrapper('Category__c', 'eq', c.FieloCMS__Category__c));
                }
                if(c.FieloCMS__Tag__c != null){
                    FilterWrapper filter = new FilterWrapper('Id', 'in', null);
                    if(c.FieloCMS__Category__c != null){
                        filter.andOrOperator = 'and';
                    }
                    filter.subQueryFilter = new SubQueryFilter('Course__c', 'FieloCMS__TagItem__c', new List<FilterWrapper>{new FilterWrapper('FieloCMS__Tag__c','eq',c.FieloCMS__Tag__c)});
                    dynamicFilters.add(filter);
                }

                List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                    OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c),
                    null,
                    null,
                    null,
                    member.FieloPLT__Program__c,
                    member.Id,
                    c.FilterByDependency__c,
                    c.FilterBySegment__c,
                    c.FilterByNotTaken__c,
                    Integer.valueof(c.FieloCMS__Limit__c),
                    0,
                    'FieloELR__Order__c',
                    dynamicFilters.isEmpty() ? null : JSON.serialize(dynamicFilters)
                );
                //JSON.serialize(dynamicFilters)

                newMapData.put(c.Id, (List<Object>)courses);
            }
            if(c.FieloCMS__ComponentLibrary__r.Name == 'Course Detail'){
                String recordId = ApexPages.CurrentPage().getParameters().get( c.FieloCMS__DetailParameter__c );
                FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
                system.debug('$$$FieloCMS__FieldSet__c');
                system.debug(OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c));
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
                List<FieloELR__CourseStatus__c> courseStatus = FieloELR.CourseService.getCourseStatus(
                    new Set<String>{'Id','FieloELR__Course__c', 'FieloELR__Progress__c'},
                    null,
                    new Set<Id> {recordId},
                    member.Id,
                    1,
                    0,
                    ''
                );
                if (!courseStatus.isEmpty()) {
                    courses[0].Progress__c = courseStatus[0].FieloELR__Progress__c;
                }
                newMapData.put(c.Id, courses[0]);
            }
        }
        return newMapData;
    }

    public List<sObject> getData(FieloCMS__Component__c component, Integer pageNumber, String orderBy, String filters){
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
}