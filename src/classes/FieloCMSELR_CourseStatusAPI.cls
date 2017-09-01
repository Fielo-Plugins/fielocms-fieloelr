public class FieloCMSELR_CourseStatusAPI implements FieloCMS.DataInterface{
	public Map<Id, Object> getBulkData(List<FieloCMS__Component__c> components){
        Map<Id,Object> newMapData = new Map<Id,Object>();
        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
        //Prepare all the queries
        for(FieloCMS__Component__c c : components){
            if(c.FieloCMS__Limit__c == null)
                c.FieloCMS__Limit__c = 5;

            if(c.FieloCMS__ComponentLibrary__r.Name == 'Course Status'){
                List<FieloELR__CourseStatus__c> courseStatus = FieloELR.CourseService.getCourseStatus(
		            FieloCMSPLT_OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c),
		            null,
		            null,
		            memberId,
		            Integer.valueof(c.FieloCMS__Limit__c),
		            0,
		            'FieloELR__Course__r.FieloELR__Order__c'
		        );
                newMapData.put(c.Id, courseStatus);
            }
        }
        return newMapData;
    }

    public List<sObject> getData(FieloCMS__Component__c component, Integer pageNumber, String orderBy, String filters){
        if(component.FieloCMS__Limit__c == null)
            component.FieloCMS__Limit__c = 5;

        //Member Id
        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();

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

        if(component.FieloCMS__ComponentLibrary__r.Name == 'Course Status'){
            List<FieloELR__CourseStatus__c> courseStatus = FieloELR.CourseService.getCourseStatus(
	            FieloCMSPLT_OrganizationUtil.getFieldSet(component.FieloCMS__FieldSet__c),
	            null,
	            null,
	            memberId,
	            Integer.valueof(component.FieloCMS__Limit__c),
	            offset,
	            'FieloELR__Course__r.FieloELR__Order__c'
	        );
            return courseStatus;
        }

        return null;
    }
}