global class FieloCMSELR_CourseAPI implements FieloCMS.DataInterface{

    public Map<Id, Object> getBulkData(List<FieloCMS__Component__c> components){
        Map<Id,Object> newMapData = new Map<Id,Object>();
        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
        //Prepare all the queries
        for(FieloCMS__Component__c c : components){
            if(c.FieloCMS__Limit__c == null)
                c.FieloCMS__Limit__c = 5;

            if (c.FieloCMS__ComponentLibrary__r.Name == 'My Courses') {
                FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];

                List<FieloCMSPLT_FilterService.FilterWrapper> dynamicFilters = new List<FieloCMSPLT_FilterService.FilterWrapper>();
                if(c.FieloCMS__Category__c != null){
                    dynamicFilters.add(new FieloCMSPLT_FilterService.FilterWrapper(null,null,'FieloCMSELR_Category__c', 'equals', c.FieloCMS__Category__c, null));
                }
                if(c.FieloCMS__Tag__c != null){
                    FieloCMSPLT_FilterService.SubQueryFilter sqf = new FieloCMSPLT_FilterService.SubQueryFilter('FieloCMSELR_Course__c','FieloCMS__TagItem__c',new List<FieloCMSPLT_FilterService.FilterWrapper>{new FieloCMSPLT_FilterService.FilterWrapper(null,null,'FieloCMS__Tag__c','equals',c.FieloCMS__Tag__c,null)});
                    dynamicFilters.add(new FieloCMSPLT_FilterService.FilterWrapper('and',null,'Id',sqf,null));
                }

                FieloCMSPLT_FilterService.FilterWrapper filter = new FieloCMSPLT_FilterService.FilterWrapper(
                    'and',
                    null,
                    'Id',
                    new FieloCMSPLT_FilterService.SubQueryFilter(
                        'FieloELR__Course__c',
                        'FieloELR__CourseStatus__c',
                        new List<FieloCMSPLT_FilterService.FilterWrapper>{
                            new FieloCMSPLT_FilterService.FilterWrapper(null, null, 'FieloELR__Member__c', 'equals', memberId, null)

                        }),
                    null
                );
                dynamicFilters.add(filter);

                List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                    FieloCMSPLT_OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c),
                    null,
                    null,
                    null,
                    member.FieloPLT__Program__c,
                    member.Id,
                    false,
                    false,
                    false,
                    Integer.valueof(c.FieloCMS__Limit__c),
                    0,
                    'LastModifiedDate',
                    dynamicFilters.isEmpty() ? null : JSON.serialize(dynamicFilters)
                );

                newMapData.put(c.Id, (List<Object>)courses);

            } else if(c.FieloCMS__ComponentLibrary__r.Name == 'Courses'){

                FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
                
                List<FieloCMSPLT_FilterService.FilterWrapper> dynamicFilters = new List<FieloCMSPLT_FilterService.FilterWrapper>();
                if(c.FieloCMS__Category__c != null){
                    dynamicFilters.add(new FieloCMSPLT_FilterService.FilterWrapper(null,null,'FieloCMSELR_Category__c', 'equals', c.FieloCMS__Category__c, null));
                }
                if(c.FieloCMS__Tag__c != null){
                    FieloCMSPLT_FilterService.SubQueryFilter sqf = new FieloCMSPLT_FilterService.SubQueryFilter('FieloCMSELR_Course__c','FieloCMS__TagItem__c',new List<FieloCMSPLT_FilterService.FilterWrapper>{new FieloCMSPLT_FilterService.FilterWrapper(null,null,'FieloCMS__Tag__c','equals',c.FieloCMS__Tag__c,null)});
                    dynamicFilters.add(new FieloCMSPLT_FilterService.FilterWrapper('and',null,'Id',sqf,null));
                }

                List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                    FieloCMSPLT_OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c),
                    null,
                    null,
                    null,
                    member.FieloPLT__Program__c,
                    member.Id,
                    c.FieloCMSELR_FilterByDependency__c,
                    c.FieloCMSELR_FilterBySegment__c,
                    c.FieloCMSELR_FilterByNotTaken__c,
                    Integer.valueof(c.FieloCMS__Limit__c),
                    0,
                    'FieloELR__Order__c',
                    dynamicFilters.isEmpty() ? null : JSON.serialize(dynamicFilters)
                );
                newMapData.put(c.Id, (List<Object>)courses);

            } else if(c.FieloCMS__ComponentLibrary__r.Name == 'Course Detail'){

                String recordId = ApexPages.CurrentPage().getParameters().get( c.FieloCMS__DetailParameter__c );
                FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
                List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                    FieloCMSPLT_OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c),
                    null,
                    null,
                    new Set<Id>{recordId},
                    member.FieloPLT__Program__c,
                    member.Id,
                    false,
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

    public List<sObject> getData(FieloCMS__Component__c component, Integer pageNumber, String orderBy, String filters){
        
        List<FieloCMSPLT_FilterService.FilterWrapper> filtersList = new List<FieloCMSPLT_FilterService.FilterWrapper>();
        if(String.isNotBlank(filters)){
            //List<FilterService.FilterWrapper> filtersList = (List<FilterService.FilterWrapper>) JSON.deserialize(filters, List<FilterService.FilterWrapper>.class);
            filtersList.addAll((List<FieloCMSPLT_FilterService.FilterWrapper>) JSON.deserialize(filters, List<FieloCMSPLT_FilterService.FilterWrapper>.class));
            if(!filtersList.isEmpty()){
                for(Integer i = filtersList.size() - 1; i > 0; i--){
                    if(filtersList[i].field == 'FieloCMS_Category__c' || filtersList[i].field == 'FieloCMS__Tag__c'){
                        if(filtersList[i].value != null){
                            component.put(filtersList[i].field, filtersList[i].value);
                        }
                        filtersList.remove(i);
                    }else if(String.isBlank(filtersList[i].value)){
                        filtersList.remove(i);
                    }
                }
            }
        }

        FieloPLT__Program__c program = FieloCMSPLT_ProgramService.getCurrentProgram();                
        if(component.FieloCMS__Limit__c == null)
            component.FieloCMS__Limit__c = 5;

        if(component.FieloCMS__Category__c != null){
            filtersList.add(new FieloCMSPLT_FilterService.FilterWrapper(null,null,'FieloCMSELR_Category__c', 'eq', component.FieloCMS__Category__c, null));
        }
        if(component.FieloCMS__Tag__c != null){
            FieloCMSPLT_FilterService.SubQueryFilter sqf = new FieloCMSPLT_FilterService.SubQueryFilter('FieloCMSELR_Course__c','FieloCMS__TagItem__c',new List<FieloCMSPLT_FilterService.FilterWrapper>{new FieloCMSPLT_FilterService.FilterWrapper(null,null,'FieloCMS__Tag__c','equals',component.FieloCMS__Tag__c,null)});
            filtersList.add(new FieloCMSPLT_FilterService.FilterWrapper('and',null,'Id',sqf,null));
        }   

        //Calculate the offset from the Page Number
        Integer offset = Integer.valueOf(component.FieloCMS__Limit__c * (pageNumber - 1));

        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
        if (component.FieloCMS__ComponentLibrary__r.Name == 'Courses') {
            List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                FieloCMSPLT_OrganizationUtil.getFieldSet(component.FieloCMS__FieldSet__c),
                null,
                null,
                null,
                program.Id,
                memberId,
                component.FieloCMSELR_FilterByDependency__c,
                component.FieloCMSELR_FilterBySegment__c,
                component.FieloCMSELR_FilterByNotTaken__c,
                Integer.valueof(component.FieloCMS__Limit__c),
                offset,
                'FieloELR__Order__c',
                filtersList.isEmpty() ? null : JSON.serialize(filtersList)
            );
            return (List<sObject>) courses;
        }else if(component.FieloCMS__ComponentLibrary__r.Name == 'My Courses'){
            FieloCMSPLT_FilterService.FilterWrapper filter = new FieloCMSPLT_FilterService.FilterWrapper(
                'and',
                null,
                'Id',
                new FieloCMSPLT_FilterService.SubQueryFilter(
                    'FieloELR__Course__c',
                    'FieloELR__CourseStatus__c',
                    new List<FieloCMSPLT_FilterService.FilterWrapper>{
                        new FieloCMSPLT_FilterService.FilterWrapper(null, null, 'FieloELR__Member__c', 'equals', memberId, null)
                    }),
                null
            );
            filtersList.add(filter);

            List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                FieloCMSPLT_OrganizationUtil.getFieldSet(component.FieloCMS__FieldSet__c),
                null,
                null,
                null,
                program.Id,
                memberId,
                false,
                false,
                false,
                Integer.valueof(component.FieloCMS__Limit__c),
                0,
                'LastModifiedDate',
                filtersList.isEmpty() ? null : JSON.serialize(filtersList)
            );
        }
        
        return null;
    }
}