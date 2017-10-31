
{
  "Libraries" : [ {
    "Name" : "FieloCMSELR",
    "FieloCMS__Version__c":1.00,
    "pageSettings" : [ {
      "Name" : "Module > Related > Post",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"Name\"}",
      "FieloPLT__Object__c" : "FieloELR__Module__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__StandardActions__c" : "Delete;New",
      "FieloPLT__TargetObject__c" : "FieloCMS__Post__c",
      "FieloPLT__Type__c" : "Related",
      "FieloPLT__DataFilters__c" : "{\"FieloCMS__Category__c\":\"{!record.FieloCMSELR_ContentCategory__c}\"}",
      "FieloPLT__Visibility__c" : "[ \r\n{\"field\":\"FieloCMSELR_ContentCategory__c\", \r\n\"operator\":\"not equals\", \r\n\"value\":\"\", \r\n\"andOrOperator\":\"\"} \r\n]"
    }, {
      "Name" : "Module > Related > Media",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"Name\"}",
      "FieloPLT__Object__c" : "FieloELR__Module__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__StandardActions__c" : "Delete;New",
      "FieloPLT__TargetObject__c" : "FieloCMS__Media__c",
      "FieloPLT__Type__c" : "Related",
      "FieloPLT__DataFilters__c" : "{\"FieloCMS__Category__c\":\"{!record.FieloCMSELR_ContentCategory__c}\"}",
      "FieloPLT__Visibility__c" : "[ \r\n{\"field\":\"FieloCMSELR_ContentCategory__c\", \r\n\"operator\":\"not equals\", \r\n\"value\":\"\", \r\n\"andOrOperator\":\"\"} \r\n]"
    }, {
      "Name" : "Course > Related > Media",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"Name\"}",
      "FieloPLT__Object__c" : "FieloELR__Course__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__StandardActions__c" : "Delete;New",
      "FieloPLT__TargetObject__c" : "FieloCMS__Media__c",
      "FieloPLT__Type__c" : "Related",
      "FieloPLT__DataFilters__c" : "{\"FieloCMS__Category__c\":\"{!record.FieloCMSELR_ContentCategory__c}\"}",
      "FieloPLT__Visibility__c" : "[ \r\n{\"field\":\"FieloCMSELR_ContentCategory__c\", \r\n\"operator\":\"not equals\", \r\n\"value\":\"\", \r\n\"andOrOperator\":\"\"} \r\n]"
    }, {
      "Name" : "Course > Related > Post",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"Name\"}",
      "FieloPLT__Object__c" : "FieloELR__Course__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__StandardActions__c" : "Delete;New",
      "FieloPLT__TargetObject__c" : "FieloCMS__Post__c",
      "FieloPLT__Type__c" : "Related",
      "FieloPLT__DataFilters__c" : "{\"FieloCMS__Category__c\":\"{!record.FieloCMSELR_ContentCategory__c}\"}",
      "FieloPLT__Visibility__c" : "[ \r\n{\"field\":\"FieloCMSELR_ContentCategory__c\", \r\n\"operator\":\"not equals\", \r\n\"value\":\"\"} \r\n]"
    }, {
      "Name" : "Course > View",
      "FieloPLT__Buttons__c" : "{\"Label\":\"Enable Content\",\"Type\":\"Remote\",\"Action\":\"FieloCMSELR_CourseCategoryButton\",\"Reflection\":true}",
      "FieloPLT__Object__c" : "FieloELR__Course__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__StandardActions__c" : "Edit;Delete;View;Settings",
      "FieloPLT__Type__c" : "View",
      "FieloPLT__Visibility__c" : "[ \r\n{\"field\":\"FieloCMSELR_ContentCategory__c\", \r\n\"operator\":\"equals\", \r\n\"value\":\"\", \r\n\"andOrOperator\":\"\"} \r\n]"
    } ]
  } ]
}
