global class QuestionResponseAPI implements FieloCMS.DataInterface, FieloCMS.ViewInterface {
	global Map<Id, Object> getBulkData(List<FieloCMS__Component__c> components){
        Map<Id,Object> newMapData = new Map<Id,Object>();
        Id memberId = MemberService.getCurrentMemberId();
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

    global ApexPages.Component getComponent(FieloCMS__Component__c c){
        Component.Widget4 quiz = new Component.Widget4(config = c);
        return quiz;        
    }

    public sObject[] records { get {
    	sObject[] rows = new List<sObject>();
    	Id memberId = MemberService.getCurrentMemberId();
        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
        Id moduleResponseId = ApexPages.CurrentPage().getParameters().get('id');
        FieloELR.ModuleService.ModuleResponseResult moduleResponseResult = FieloELR.ModuleService.getModuleResponse(
        	moduleResponseId,
        	new Set<String> {'Name'},
        	new Set<String> {'Name','FieloELR__Type__c'},
        	new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c'}
        );

        sObject row = (sObject) new FieloELR__QuestionResponse__c();
        for(FieloELR.QuestionService.QuestionResponseResult qrr: moduleResponseResult.questions) {
        	row = (sObject) new FieloELR__QuestionResponse__c();
        	row.put('FieloELR__Question__c', qrr.question.Id);
        	row.put('FieloELR__IsCorrect__c', qrr.questionResponse.FieloELR__IsCorrect__c);
        	row.put('FieloELR__NumberOfAttempt__c', qrr.numberOfAttempts);
            row.put('FieloELR__PartialGradeValue__c', qrr.questionResponse.FieloELR__PartialGradeValue__c);
            // Proxy Fields
            row.put('QuestionType__c', qrr.question.FieloELR__Type__c);
        	row.put('CorrectAnswers__c', qrr.correctedAnswers);
        	rows.add(row);
        }

        return rows;
    }
    	set;
    }

    public List<sObject> answers { get {
    	List<sObject> rows = new List<sObject>();
    	Id memberId = MemberService.getCurrentMemberId();
        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id =: memberId];
        Id moduleResponseId = ApexPages.CurrentPage().getParameters().get('id');
        FieloELR.ModuleService.ModuleResponseResult moduleResponseResult = FieloELR.ModuleService.getModuleResponse(
        	moduleResponseId,
        	new Set<String> {'Name'},
        	new Set<String> {'Name','FieloELR__Type__c'},
        	new Set<String> {'FieloELR__Question__c','FieloELR__AnswerOptionText__c','Status__c','FieloELR__MatchingText__c'}
        );

        sObject row;
        for(FieloELR.QuestionService.QuestionResponseResult qrr: moduleResponseResult.questions) {
        	if (qrr.answerWrappers != null) {
        		for(FieloELR.QuestionService.AnswerWrapper aw: qrr.answerWrappers) {
	        		row = (sObject) new FieloELR__AnswerOption__c();
	        		row.put('FieloELR__Question__c', aw.answerOption.FieloELR__Question__c);
	        		row.put('FieloELR__AnswerOptionText__c', aw.answerOption.FieloELR__AnswerOptionText__c);
	        		row.put('FieloELR__IsCorrect__c', aw.answerOption.FieloELR__IsCorrect__c);
	        		row.put('Status__c', aw.answerStatus);
	        		rows.add(row);
	        	}
        	}
        }

        return rows;
    }
    	set;
    }
}