{
  "plugins" : [ {
    "Name" : "ElrPlugin",
    "components" : [
			  {
				"FieloCMS__ControlClass__c": "FieloCMS.StandardAPI", 
				"FieloCMS__CssClasses__c": "", 
				"FieloCMS__DataClass__c": "CourseAPI", 
				"FieloCMS__DefaultFields__c": "Name,FieloELR__Order__c,FieloELR__Status__c", 
				"FieloCMS__DeveloperName__c": "ElrPlugin.Courses", 
				"FieloCMS__ExcludeFields__c": "Id,OwnerId,IsDeleted,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp", 
				"FieloCMS__Icon__c": "fa-puzzle-piece", 
				"FieloCMS__Layouts__c": "Grid;Table", 
				"FieloCMS__RecordType__c": "List", 
				"FieloCMS__Subcomponents__c": "[{\"apiName\": \"ProgressBar\",\"label\": \"Progress\", \"reflectionClass\": \"CourseAPI\", \"type\": \"Subcomponent\", \"fieldName\":\"Id\"},{\"apiName\": \"CourseAction\",\"label\": \"Action\", \"reflectionClass\": \"CourseAPI.CourseAction\", \"type\": \"Subcomponent\", \"fieldName\":\"Id\"}]", 
				"FieloCMS__Visibility__c": "Both", 
				"FieloCMS__sObject__c": "FieloELR__Course__c", 
				"Name": "Courses"
			  }, 
			  {
				"FieloCMS__ControlClass__c": "FieloCMS.StandardAPI", 
				"FieloCMS__CssClasses__c": "", 
				"FieloCMS__DataClass__c": "CourseAPI", 
				"FieloCMS__DefaultFields__c": "Name,FieloELR__Description__c", 
				"FieloCMS__DeveloperName__c": "ElrPlugin.CourseDetail", 
				"FieloCMS__ExcludeFields__c": "Id,OwnerId,IsDeleted,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp", 
				"FieloCMS__Icon__c": "fa-puzzle-piece", 
				"FieloCMS__Layouts__c": "View", 
				"FieloCMS__RecordType__c": "Record", 
				"FieloCMS__Subcomponents__c": "", 
				"FieloCMS__Visibility__c": "Both", 
				"FieloCMS__sObject__c": "FieloELR__Course__c", 
				"Name": "Course Detail"
			  }, 
			  {
				"FieloCMS__ControlClass__c": "FieloCMS.StandardAPI", 
				"FieloCMS__CssClasses__c": "", 
				"FieloCMS__DataClass__c": "CourseAPI", 
				"FieloCMS__DefaultFields__c": "Name,FieloELR__ApprovalGrade__c", 
				"FieloCMS__DeveloperName__c": "ElrPlugin.Modules", 
				"FieloCMS__ExcludeFields__c": "Id,OwnerId,IsDeleted,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp", 
				"FieloCMS__Icon__c": "fa-puzzle-piece", 
				"FieloCMS__Layouts__c": "Grid;Table", 
				"FieloCMS__RecordType__c": "List", 
				"FieloCMS__Subcomponents__c": "[{\"apiName\": \"CourseAction\",\"label\": \"Action\", \"reflectionClass\": \"CourseAPI.CourseAction\", \"type\": \"Subcomponent\", \"fieldName\":\"Id\"}]", 
				"FieloCMS__Visibility__c": "Both", 
				"FieloCMS__sObject__c": "FieloELR__Module__c", 
				"Name": "Modules"
			  }, 
			  {
				"FieloCMS__ControlClass__c": "FieloCMS.StandardAPI", 
				"FieloCMS__CssClasses__c": "", 
				"FieloCMS__DataClass__c": "FieloCMS.StandardAPI", 
				"FieloCMS__DefaultFields__c": "", 
				"FieloCMS__DeveloperName__c": "ElrPlugin.Quiz", 
				"FieloCMS__ExcludeFields__c": "", 
				"FieloCMS__Icon__c": "fa-puzzle-piece", 
				"FieloCMS__Layouts__c": "Edit", 
				"FieloCMS__RecordType__c": "Widget", 
				"FieloCMS__Subcomponents__c": "", 
				"FieloCMS__Visibility__c": "Both", 
				"FieloCMS__sObject__c": "", 
				"Name": "Quiz"
			  }, 
			  {
				"FieloCMS__ControlClass__c": "FieloCMS.StandardAPI", 
				"FieloCMS__CssClasses__c": "", 
				"FieloCMS__DataClass__c": "FieloCMS.StandardAPI", 
				"FieloCMS__DefaultFields__c": "Name,FieloELR__GradePercent__c,FieloELR__IsApproved__c,FieloELR__Date__c", 
				"FieloCMS__DeveloperName__c": "ElrPlugin.ModuleResponse", 
				"FieloCMS__ExcludeFields__c": "Id,OwnerId,IsDeleted,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp", 
				"FieloCMS__Icon__c": "fa-puzzle-piece", 
				"FieloCMS__Layouts__c": "View", 
				"FieloCMS__RecordType__c": "Record", 
				"FieloCMS__Subcomponents__c": "", 
				"FieloCMS__Visibility__c": "Both", 
				"FieloCMS__sObject__c": "FieloELR__ModuleResponse__c", 
				"Name": "Module Response"
			  }, 
			  {
				"FieloCMS__ControlClass__c": "FieloCMS.StandardAPI", 
				"FieloCMS__CssClasses__c": "", 
				"FieloCMS__DataClass__c": "FieloCMS.StandardAPI", 
				"FieloCMS__DefaultFields__c": "Name", 
				"FieloCMS__DeveloperName__c": "ElrPlugin.ModuleRecord", 
				"FieloCMS__ExcludeFields__c": "Id,OwnerId,IsDeleted,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp", 
				"FieloCMS__Icon__c": "fa-puzzle-piece", 
				"FieloCMS__Layouts__c": "", 
				"FieloCMS__RecordType__c": "Record", 
				"FieloCMS__Subcomponents__c": "", 
				"FieloCMS__Visibility__c": "Both", 
				"FieloCMS__sObject__c": "FieloELR__Module__c", 
				"Name": "Module Record"
			  }
			],
	"models" : [ {
      "Name" : "Course Detail",
      "FieloCMS__Category__c" : "Miscelaneas",
      "FieloCMS__Icon__c" : "fielosf-icon-content",
      "FieloCMS__Type__c" : "Page",
      "FieloCMS__XMLReference__c" : "{\n  \"pages\" : [ {\n    \"reference\" : \"a0yf4000000HJvqAAG\",\n    \"recordTypeName\" : \"Page\",\n    \"Name\" : \"Course Detail\",\n    \"FieloCMS__Icon__c\" : \"fielo-icon-content\",\n    \"sections\" : [ {\n      \"FieloCMS__Order__c\" : 93,\n      \"FieloCMS__Width__c\" : \"12\",\n      \"subsections\" : [ {\n        \"FieloCMS__Order__c\" : 94,\n        \"FieloCMS__Width__c\" : \"12\",\n        \"components\" : [ {\n          \"reference\" : \"a0sf4000000HLqHAAW\",\n          \"recordTypeName\" : \"Record\",\n          \"componentLibrary\" : \"Course Detail\",\n          \"Name\" : \"Course Detail\",\n          \"FieloCMS__CSSClasses__c\" : \"fielo-form-view\",\n          \"FieloCMS__Columns__c\" : 2,\n          \"FieloCMS__Delay__c\" : 2500,\n          \"FieloCMS__DetailParameter__c\" : \"id\",\n          \"FieloCMS__FieldSet__c\" : \"[{\\\"showLabel\\\":true,\\\"label\\\":\\\"Course Name\\\",\\\"apiName\\\":\\\"Name\\\",\\\"type\\\":\\\"STRING\\\"},{\\\"showLabel\\\":true,\\\"label\\\":\\\"Description\\\",\\\"apiName\\\":\\\"FieloELR__Description__c\\\",\\\"type\\\":\\\"TEXTAREA\\\"}]]\",\n          \"FieloCMS__LayoutMode__c\" : \"Post\",\n          \"FieloCMS__Layout__c\" : \"View\",\n          \"FieloCMS__Limit__c\" : 6,\n          \"FieloCMS__Order__c\" : 1,\n          \"FieloCMS__ParameterName__c\" : \"paginatorBinding\",\n          \"FieloCMS__Rows__c\" : 2,\n          \"FieloCMS__Title__c\" : \"Course Detail\",\n          \"FieloCMS__Width__c\" : 0\n        }, {\n          \"reference\" : \"a0sf4000000HRKOAA4\",\n          \"componentReference\" : \"a0sf4000000HY1QAAW\",\n          \"recordTypeName\" : \"List\",\n          \"componentLibrary\" : \"Modules\",\n          \"Name\" : \"Modules\",\n          \"FieloCMS__CSSClasses__c\" : \"cms-elr-module-list-action cms-elr-paginator-filter\",\n          \"FieloCMS__Columns__c\" : 2,\n          \"FieloCMS__DetailParameter__c\" : \"id\",\n          \"FieloCMS__DetailURL__c\" : \"FieloCMS__Page?pageId=a0yf4000000HZwQAAW\",\n          \"FieloCMS__DetailView__c\" : \"Internal page\",\n          \"FieloCMS__FieldSet__c\" : \"[{\\\"type\\\":\\\"STRING\\\",\\\"apiName\\\":\\\"Name\\\",\\\"label\\\":\\\"Module Name\\\",\\\"showLabel\\\":true,\\\"orderBy\\\":\\\"disabled\\\",\\\"linkToDetail\\\":true},{\\\"type\\\":\\\"PERCENT\\\",\\\"apiName\\\":\\\"FieloELR__ApprovalGrade__c\\\",\\\"label\\\":\\\"Approval Grade\\\",\\\"showLabel\\\":true,\\\"orderBy\\\":\\\"disabled\\\",\\\"linkToDetail\\\":false},{\\\"showLabel\\\":true,\\\"fieldName\\\":\\\"Id\\\",\\\"type\\\":\\\"Subcomponent\\\",\\\"reflectionClass\\\":\\\"CourseAPI.CourseAction\\\",\\\"label\\\":\\\"Action\\\",\\\"apiName\\\":\\\"CourseAction\\\"}]]\",\n          \"FieloCMS__Layout__c\" : \"Table\",\n          \"FieloCMS__Limit__c\" : 6,\n          \"FieloCMS__Order__c\" : 2,\n          \"FieloCMS__ParameterName__c\" : \"paginatorBinding\",\n          \"FieloCMS__Rows__c\" : 2,\n          \"FieloCMS__Title__c\" : \"Modules\",\n          \"FieloCMS__Width__c\" : 0\n        } ]\n      } ]\n    } ]\n  } ]\n}"
    }, {
      "Name" : "Module Response Detail",
      "FieloCMS__Category__c" : "Miscelaneas",
      "FieloCMS__Icon__c" : "fielosf-icon-content",
      "FieloCMS__Type__c" : "Page",
      "FieloCMS__XMLReference__c" : "{\n  \"pages\" : [ {\n    \"reference\" : \"a0yf4000000HegRAAS\",\n    \"recordTypeName\" : \"Page\",\n    \"Name\" : \"Module Response Detail\",\n    \"FieloCMS__Icon__c\" : \"fielo-icon-content\",\n    \"sections\" : [ {\n      \"FieloCMS__Order__c\" : 97,\n      \"FieloCMS__Width__c\" : \"12\",\n      \"subsections\" : [ {\n        \"FieloCMS__Order__c\" : 98,\n        \"FieloCMS__Width__c\" : \"12\",\n        \"components\" : [ {\n          \"reference\" : \"a0sf4000000HfNgAAK\",\n          \"recordTypeName\" : \"Record\",\n          \"componentLibrary\" : \"Module Response\",\n          \"Name\" : \"Module Response\",\n          \"FieloCMS__CSSClasses__c\" : \"fielo-form-view\",\n          \"FieloCMS__Columns__c\" : 2,\n          \"FieloCMS__Delay__c\" : 2500,\n          \"FieloCMS__DetailParameter__c\" : \"id\",\n          \"FieloCMS__FieldSet__c\" : \"[{\\\"type\\\":\\\"STRING\\\",\\\"apiName\\\":\\\"Name\\\",\\\"label\\\":\\\"Module Response Name\\\",\\\"showLabel\\\":true},{\\\"type\\\":\\\"PERCENT\\\",\\\"apiName\\\":\\\"FieloELR__GradePercent__c\\\",\\\"label\\\":\\\"Grade %\\\",\\\"showLabel\\\":true},{\\\"type\\\":\\\"BOOLEAN\\\",\\\"apiName\\\":\\\"FieloELR__IsApproved__c\\\",\\\"label\\\":\\\"Is Approved\\\",\\\"showLabel\\\":true},{\\\"type\\\":\\\"DATE\\\",\\\"apiName\\\":\\\"FieloELR__Date__c\\\",\\\"label\\\":\\\"Date\\\",\\\"showLabel\\\":true}]]\",\n          \"FieloCMS__LayoutMode__c\" : \"Post\",\n          \"FieloCMS__Layout__c\" : \"View\",\n          \"FieloCMS__Limit__c\" : 6,\n          \"FieloCMS__Order__c\" : 1,\n          \"FieloCMS__ParameterName__c\" : \"paginatorBinding\",\n          \"FieloCMS__Rows__c\" : 2,\n          \"FieloCMS__Title__c\" : \"Module Response Detail\",\n          \"FieloCMS__Width__c\" : 0\n        } ]\n      } ]\n    } ]\n  } ]\n}"
    }, {
      "Name" : "Module Detail",
      "FieloCMS__Category__c" : "Miscelaneas",
      "FieloCMS__Icon__c" : "fielosf-icon-content",
      "FieloCMS__Type__c" : "Page",
      "FieloCMS__XMLReference__c" : "{\n  \"pages\" : [ {\n    \"reference\" : \"a0yf4000000HZwQAAW\",\n    \"recordTypeName\" : \"Page\",\n    \"Name\" : \"Module Detail\",\n    \"FieloCMS__Icon__c\" : \"fielo-icon-content\",\n    \"sections\" : [ {\n      \"FieloCMS__Order__c\" : 95,\n      \"FieloCMS__Width__c\" : \"12\",\n      \"subsections\" : [ {\n        \"FieloCMS__Order__c\" : 96,\n        \"FieloCMS__Width__c\" : \"12\",\n        \"components\" : [ {\n          \"reference\" : \"a0sf4000000HY1QAAW\",\n          \"recordTypeName\" : \"Record\",\n          \"componentLibrary\" : \"Module Record\",\n          \"Name\" : \"Module Record\",\n          \"FieloCMS__CSSClasses__c\" : \"fielo-form-view\",\n          \"FieloCMS__Columns__c\" : 2,\n          \"FieloCMS__Delay__c\" : 2500,\n          \"FieloCMS__DetailParameter__c\" : \"id\",\n          \"FieloCMS__FieldSet__c\" : \"[{\\\"type\\\":\\\"STRING\\\",\\\"apiName\\\":\\\"Name\\\",\\\"label\\\":\\\"Module Name\\\",\\\"showLabel\\\":true,\\\"autocomplete\\\":\\\"\\\",\\\"placeholder\\\":\\\"\\\",\\\"inlineHelpText\\\":\\\"\\\",\\\"readOnly\\\":false,\\\"required\\\":false},{\\\"required\\\":false,\\\"readOnly\\\":false,\\\"inlineHelpText\\\":\\\"\\\",\\\"placeholder\\\":\\\"\\\",\\\"autocomplete\\\":\\\"\\\",\\\"showLabel\\\":true,\\\"label\\\":\\\"Description\\\",\\\"apiName\\\":\\\"FieloELR__Description__c\\\",\\\"type\\\":\\\"TEXTAREA\\\"}]]\",\n          \"FieloCMS__LayoutMode__c\" : \"Post\",\n          \"FieloCMS__Layout__c\" : \"View\",\n          \"FieloCMS__Limit__c\" : 6,\n          \"FieloCMS__Order__c\" : 1,\n          \"FieloCMS__ParameterName__c\" : \"paginatorBinding\",\n          \"FieloCMS__Rows__c\" : 2,\n          \"FieloCMS__Title__c\" : \"Module\",\n          \"FieloCMS__Width__c\" : 0\n        }, {\n          \"reference\" : \"a0sf4000000HYQgAAO\",\n          \"recordTypeName\" : \"Widget\",\n          \"componentLibrary\" : \"Quiz\",\n          \"Name\" : \"Quiz\",\n          \"FieloCMS__CSSClasses__c\" : \"cms-elr-quiz\",\n          \"FieloCMS__Columns__c\" : 2,\n          \"FieloCMS__Delay__c\" : 2500,\n          \"FieloCMS__DetailParameter__c\" : \"id\",\n          \"FieloCMS__Layout__c\" : \"Edit\",\n          \"FieloCMS__Limit__c\" : 6,\n          \"FieloCMS__Order__c\" : 2,\n          \"FieloCMS__ParameterName__c\" : \"paginatorBinding\",\n          \"FieloCMS__Rows__c\" : 2,\n          \"FieloCMS__Title__c\" : \"Quiz\",\n          \"FieloCMS__Width__c\" : 0\n        } ]\n      } ]\n    } ]\n  } ]\n}"
    }, {
      "Name" : "Courses",
      "FieloCMS__Category__c" : "Miscelaneas",
      "FieloCMS__Icon__c" : "fielosf-icon-content",
      "FieloCMS__Type__c" : "Page",
      "FieloCMS__XMLReference__c" : "{\n  \"pages\" : [ {\n    \"reference\" : \"a0yf4000000HIqPAAW\",\n    \"recordTypeName\" : \"Page\",\n    \"Name\" : \"Courses\",\n    \"FieloCMS__Icon__c\" : \"fielo-icon-content\",\n    \"sections\" : [ {\n      \"FieloCMS__Order__c\" : 91,\n      \"FieloCMS__Width__c\" : \"12\",\n      \"subsections\" : [ {\n        \"FieloCMS__Order__c\" : 92,\n        \"FieloCMS__Width__c\" : \"12\",\n        \"components\" : [ {\n          \"reference\" : \"a0sf4000000HTOtAAO\",\n          \"componentReference\" : \"a0sf4000000HLqHAAW\",\n          \"recordTypeName\" : \"List\",\n          \"componentLibrary\" : \"Courses\",\n          \"Name\" : \"Courses\",\n          \"FieloCMS__CSSClasses__c\" : \"cms-elr-list-action cms-elr-list-progress\",\n          \"FieloCMS__Columns__c\" : 2,\n          \"FieloCMS__DetailParameter__c\" : \"id\",\n          \"FieloCMS__DetailURL__c\" : \"FieloCMS__Page?pageId=a0yf4000000HJvqAAG\",\n          \"FieloCMS__DetailView__c\" : \"Internal page\",\n          \"FieloCMS__FieldSet__c\" : \"[{\\\"linkToDetail\\\":true,\\\"orderBy\\\":\\\"disabled\\\",\\\"showLabel\\\":true,\\\"label\\\":\\\"Course Name\\\",\\\"apiName\\\":\\\"Name\\\",\\\"type\\\":\\\"STRING\\\"},{\\\"showLabel\\\":true,\\\"fieldName\\\":\\\"Id\\\",\\\"type\\\":\\\"Subcomponent\\\",\\\"reflectionClass\\\":\\\"CourseAPI\\\",\\\"label\\\":\\\"Progress\\\",\\\"apiName\\\":\\\"ProgressBar\\\"},{\\\"showLabel\\\":true,\\\"fieldName\\\":\\\"Id\\\",\\\"type\\\":\\\"Subcomponent\\\",\\\"reflectionClass\\\":\\\"CourseAPI.CourseAction\\\",\\\"label\\\":\\\"Action\\\",\\\"apiName\\\":\\\"CourseAction\\\"}]]\",\n          \"FieloCMS__Layout__c\" : \"Table\",\n          \"FieloCMS__Limit__c\" : 50,\n          \"FieloCMS__Order__c\" : 1,\n          \"FieloCMS__ParameterName__c\" : \"paginatorBinding\",\n          \"FieloCMS__Rows__c\" : 2,\n          \"FieloCMS__Title__c\" : \"Courses\",\n          \"FieloCMS__Width__c\" : 0\n        } ]\n      } ]\n    } ]\n  } ]\n}"
    } ]
	} ]
}