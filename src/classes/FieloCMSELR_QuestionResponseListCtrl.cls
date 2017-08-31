public class FieloCMSELR_QuestionResponseListCtrl implements FieloCMS.DataInterface{
	public Map<Id, Object> getBulkData(List<FieloCMS__Component__c> components){
        Map<Id,Object> newMapData = new Map<Id,Object>();
        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
        //Prepare all the queries
        for(FieloCMS__Component__c c : components){
            if(c.FieloCMS__Limit__c == null)
                c.FieloCMS__Limit__c = 5;

            List<Map<String,String>> fieldSet = (List<Map<String,String>>) JSON.deserialize(c.FieloCMS__FieldSet__c, List<Map<String,String>>.class );
            
            Set<String> fields = new Set<String>();

            for(Map<String,String> field: fieldSet) {
            	if (field.containsKey('apiName')) {
            		fields.add(field.get('apiName'));
            	}
            }

            String whereCondition;
            Id moduleResponseId;
            if(String.isNotBlank(c.FieloCMS__DetailParameter__c) && ApexPages.CurrentPage().getParameters().containsKey(c.FieloCMS__DetailParameter__c)){
                moduleResponseId = ApexPages.CurrentPage().getParameters().get(c.FieloCMS__DetailParameter__c);
                whereCondition = ' FieloELR__ModuleResponse__c = \'' + moduleResponseId + '\'';
            }else{
                whereCondition += 'FieloELR__ModuleResponse__r.FieloELR__Member__c = \'' + MemberService.getCurrentMemberId() + '\'';
            }
            whereCondition += ' LIMIT ' + String.valueOf(c.FieloCMS__Limit__c);
            whereCondition += ' OFFSET 0';
            newMapData.put(c.Id, Database.query('SELECT ' + String.join(new List<String>(fields), ',') + ' FROM FieloELR__QuestionResponse__c WHERE ' + whereCondition));
        }
        system.debug(newMapData);
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

        // Assemble Where Condition
        String whereCondition = '';
        whereCondition += 'FieloELR__ModuleResponse__r.FieloELR__Member__c = \'' + MemberService.getCurrentMemberId() + '\'';
        if (recordId != null) {
        	whereCondition += ' AND FieloELR__ModuleResponse__c = \'' + recordId + '\'';
        }
        whereCondition += ' LIMIT ' + String.valueOf(component.FieloCMS__Limit__c);
        whereCondition += ' OFFSET ' + String.valueOf(offset);

        String query = 'SELECT ';
        query += String.join(new List<String>(OrganizationUtil.getFieldSet(component.FieloCMS__FieldSet__c)), ',');
        query += ' FROM FieloELR__QuestionResponse__c WHERE ';
        query += whereCondition;
        system.debug('***query');
        system.debug(query);
        return Database.query(query);
    }

    public ApexPages.Component getComponent(FieloCMS__Component__c c){
        Component.FieloCMSELR_QuestionResponseList qResp = new Component.FieloCMSELR_QuestionResponseList(config = c);
        return qResp;        
    }

    public FieloELR.ModuleService.ModuleResponseResult moduleResponseResult {get {
        if(moduleResponseResult == null){
            Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
            FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
            Id moduleResponseId = ApexPages.CurrentPage().getParameters().get('id');
            moduleResponseResult = FieloELR.ModuleService.getModuleResponse(
                moduleResponseId,
                new Set<String> {'Name'},
                new Set<String> {'Name','FieloELR__Type__c','FieloELR__Module__r.FieloELR__Course__c'},
                new Set<String> {'FieloELR__Question__c','FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c'}
            );
        }
        return moduleResponseResult;
    } set;}

    public String courseId {get{
        if (!records.isEmpty()) {
            return (String) moduleResponseResult.moduleResponse.FieloELR__Course__c;
        } else {
            return '';
        }
    }
        set;
    }
}