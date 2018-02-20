
{
  "exportType" : "update",
  "configObjects" : [ {
    "apiName" : "fieloplt__library__c",
    "fieldsToExclude" : "fieloplt__resourceid__c"
  }, {
    "apiName" : "fieloplt__ruletrigger__c",
    "fieldsToExclude" : "fieloplt__prefix__c"
  }, {
    "apiName" : "fieloplt__action__c",
    "fieldsToExclude" : "fieloplt__rulesquantity__c,fieloplt__missionsquantity__c,fieloplt__criteriafields__c"
  } ],
  "migrationRecords" : [ {
    "objectAPIName" : "fieloplt__library__c",
    "records" : [ {
      "fieldsValues" : [ {
        "apiName" : "name",
        "value" : "FieloCMSELR"
      }, {
        "apiName" : "fieloplt__version__c",
        "value" : "1.001"
      }, {
        "apiName" : "fieloplt__externalid__c",
        "value" : "FieloCMSELR4"
      } ],
      "relatedList" : [ {
        "objectAPIName" : "fieloplt__ruletrigger__c",
        "records" : [ ]
      }, {
        "objectAPIName" : "fieloplt__model__c",
        "records" : [ ]
      }, {
        "objectAPIName" : "fieloplt__pagesettings__c",
        "records" : [ {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Course > Related > Media"
          }, {
            "apiName" : "fieloplt__actions__c",
            "value" : "{\"Label\":\"Delete\",\"Type\":\"Remote\",\"Action\":\"FieloELR.RelatedListController.deleteRecord\",\"CssClass\":\"slds-button--destructive\",\"Confirm\":true}"
          }, {
            "apiName" : "fieloplt__fieldset__c",
            "value" : "{\"Name\":\"Name\"}"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloCMSELR4",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloELR__Course__c"
          }, {
            "apiName" : "fieloplt__order__c",
            "value" : "1"
          }, {
            "apiName" : "fieloplt__standardactions__c",
            "value" : "New"
          }, {
            "apiName" : "fieloplt__targetobject__c",
            "value" : "FieloCMS__Media__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Related"
          }, {
            "apiName" : "fieloplt__datafilters__c",
            "value" : "{\"FieloCMS__Category__c\":\"{!record.FieloCMSELR_ContentCategory__c}\"}"
          }, {
            "apiName" : "fieloplt__visibility__c",
            "value" : "[ \r\n{\"field\":\"FieloCMSELR_ContentCategory__c\", \r\n\"operator\":\"not equals\", \r\n\"value\":\"\", \r\n\"andOrOperator\":\"\"} \r\n]"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "CourseRelatedMedia40"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Course > Related > Post"
          }, {
            "apiName" : "fieloplt__actions__c",
            "value" : "{\"Label\":\"Delete\",\"Type\":\"Remote\",\"Action\":\"FieloELR.RelatedListController.deleteRecord\",\"CssClass\":\"slds-button--destructive\",\"Confirm\":true}"
          }, {
            "apiName" : "fieloplt__fieldset__c",
            "value" : "{\"Name\":\"Name\"}"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloCMSELR4",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloELR__Course__c"
          }, {
            "apiName" : "fieloplt__order__c",
            "value" : "1"
          }, {
            "apiName" : "fieloplt__standardactions__c",
            "value" : "New"
          }, {
            "apiName" : "fieloplt__targetobject__c",
            "value" : "FieloCMS__Post__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Related"
          }, {
            "apiName" : "fieloplt__datafilters__c",
            "value" : "{\"FieloCMS__Category__c\":\"{!record.FieloCMSELR_ContentCategory__c}\"}"
          }, {
            "apiName" : "fieloplt__visibility__c",
            "value" : "[ \r\n{\"field\":\"FieloCMSELR_ContentCategory__c\", \r\n\"operator\":\"not equals\", \r\n\"value\":\"\"} \r\n]"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "CourseRelatedPost41"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Course > View"
          }, {
            "apiName" : "fieloplt__buttons__c",
            "value" : "{\"Label\":\"Enable Content\",\"Type\":\"Remote\",\"Action\":\"FieloCMSELR_CourseCategoryButton\",\"Reflection\":true}"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloCMSELR4",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloELR__Course__c"
          }, {
            "apiName" : "fieloplt__order__c",
            "value" : "1"
          }, {
            "apiName" : "fieloplt__standardactions__c",
            "value" : "Edit;Delete;View;Settings"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "View"
          }, {
            "apiName" : "fieloplt__visibility__c",
            "value" : "[ \r\n{\"field\":\"FieloCMSELR_ContentCategory__c\", \r\n\"operator\":\"equals\", \r\n\"value\":\"\", \r\n\"andOrOperator\":\"\"} \r\n]"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "CourseView42"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Module > Related > Media"
          }, {
            "apiName" : "fieloplt__actions__c",
            "value" : "{\"Label\":\"Delete\",\"Type\":\"Remote\",\"Action\":\"FieloELR.RelatedListController.deleteRecord\",\"CssClass\":\"slds-button--destructive\",\"Confirm\":true}"
          }, {
            "apiName" : "fieloplt__fieldset__c",
            "value" : "{\"Name\":\"Name\"}"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloCMSELR4",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloELR__Module__c"
          }, {
            "apiName" : "fieloplt__order__c",
            "value" : "1"
          }, {
            "apiName" : "fieloplt__standardactions__c",
            "value" : "New"
          }, {
            "apiName" : "fieloplt__targetobject__c",
            "value" : "FieloCMS__Media__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Related"
          }, {
            "apiName" : "fieloplt__datafilters__c",
            "value" : "{\"FieloCMS__Category__c\":\"{!record.FieloCMSELR_ContentCategory__c}\"}"
          }, {
            "apiName" : "fieloplt__visibility__c",
            "value" : "[ \r\n{\"field\":\"FieloCMSELR_ContentCategory__c\", \r\n\"operator\":\"not equals\", \r\n\"value\":\"\", \r\n\"andOrOperator\":\"\"} \r\n]"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "ModuleRelatedMedia39"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Module > Related > Post"
          }, {
            "apiName" : "fieloplt__actions__c",
            "value" : "{\"Label\":\"Delete\",\"Type\":\"Remote\",\"Action\":\"FieloELR.RelatedListController.deleteRecord\",\"CssClass\":\"slds-button--destructive\",\"Confirm\":true}"
          }, {
            "apiName" : "fieloplt__fieldset__c",
            "value" : "{\"Name\":\"Name\"}"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloCMSELR4",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloELR__Module__c"
          }, {
            "apiName" : "fieloplt__order__c",
            "value" : "1"
          }, {
            "apiName" : "fieloplt__standardactions__c",
            "value" : "New"
          }, {
            "apiName" : "fieloplt__targetobject__c",
            "value" : "FieloCMS__Post__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Related"
          }, {
            "apiName" : "fieloplt__datafilters__c",
            "value" : "{\"FieloCMS__Category__c\":\"{!record.FieloCMSELR_ContentCategory__c}\"}"
          }, {
            "apiName" : "fieloplt__visibility__c",
            "value" : "[ \r\n{\"field\":\"FieloCMSELR_ContentCategory__c\", \r\n\"operator\":\"not equals\", \r\n\"value\":\"\", \r\n\"andOrOperator\":\"\"} \r\n]"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "ModuleRelatedPost38"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        } ]
      } ]
    } ]
  } ],
  "segmentsCombinations" : [ ]
}