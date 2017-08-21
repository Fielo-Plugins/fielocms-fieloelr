global with sharing class ModuleAPI implements FieloCMS.DataInterface{
	
	global Map<Id, Object> getBulkData(List<FieloCMS__Component__c> components){
        Map<Id,Object> newMapData = new Map<Id,Object>();
        Id memberId = MemberService.getCurrentMemberId();
        //Prepare all the queries
        for(FieloCMS__Component__c c : components){
            if(c.FieloCMS__Limit__c == null)
                c.FieloCMS__Limit__c = 5;

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
                newMapData.put(c.Id, (List<Object>) courses[0].FieloELR__Modules__r);
            }
        }
        return newMapData;
    }

    global List<sObject> getData(FieloCMS__Component__c component, Integer pageNumber, String orderBy, String filters){
        return null;
    }

}