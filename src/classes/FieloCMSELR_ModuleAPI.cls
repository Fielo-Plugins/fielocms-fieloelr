global with sharing class FieloCMSELR_ModuleAPI implements FieloCMS.DataInterface{
	
	public Map<Id, Object> getBulkData(List<FieloCMS__Component__c> components){
        Map<Id,Object> newMapData = new Map<Id,Object>();
        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
        //Prepare all the queries
        for(FieloCMS__Component__c c : components){
            if(c.FieloCMS__Limit__c == null)
                c.FieloCMS__Limit__c = 5;

            if(c.FieloCMS__ComponentLibrary__r.Name == 'Modules'){
                String recordId = ApexPages.CurrentPage().getParameters().get( c.FieloCMSELR_CustomDetailParameter__c );
                FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
                Set<String> fields = FieloCMSPLT_OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c);
                if (!fields.contains('FieloELR__IsActive__c')) {
                    fields.add('FieloELR__IsActive__c')
                }
                List<FieloELR__Course__c> courses = FieloELR.CourseService.getCourses(
                    new Set<String>{'Id','Name'},
                    null,
                    FieloCMSPLT_OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c),
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

                List<sObject> records = new List<sObject>();

                if (c.FieloCMS__Limit__c > courses[0].FieloELR__Modules__r.size()) {
                    records.addAll((List<sObject>)courses[0].FieloELR__Modules__r);
                } else {
                    for (Integer index=0; index < c.FieloCMS__Limit__c; index++) {
                        records.add(courses[0].FieloELR__Modules__r[index]);
                    }
                }

                newMapData.put(c.Id, (List<Object>) records);
            }
        }
        return newMapData;
    }

    public List<sObject> getData(FieloCMS__Component__c component, Integer pageNumber, String orderBy, String filters){
        return null;
    }

}