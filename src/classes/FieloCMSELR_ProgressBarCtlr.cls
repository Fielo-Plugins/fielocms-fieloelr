public class FieloCMSELR_ProgressBarCtlr implements FieloCMS.ViewSubComponentInterface {
    public ApexPages.Component getSubComponent(FieloCMS.Field field, SObject record){
    	system.debug(field);
    	system.debug(record);
        Component.FieloCMSELR_ProgressBar progress = new Component.FieloCMSELR_ProgressBar();
        return progress;
    }

    @RemoteAction
    public static List<SObject> getCourseStatus(List<String> courseIds) {
        Id memberId = FieloCMSPLT_MemberService.getCurrentMemberId();
        List<FieloELR__CourseStatus__c> courseStatus = FieloELR.CourseService.getCourseStatus(
            new Set<String>{'FieloELR__Progress__c','FieloELR__Course__c'},
            null,
            new Set<Id>((List<Id>)courseIds),
            memberId,
            100,
            0,
            'FieloELR__Course__r.FieloELR__Order__c'
        );
        return courseStatus;
    }

    public FieloCMS.Field cField {get; set;}
    public sObject cRecord {get;set;}

    public Decimal progress {get{
        if (cField.attributes.containsKey('useFieldValue')) {
            if (cField.attributes.get('useFieldValue')!=null) {
                if ((String)cField.attributes.get('useFieldValue')=='true') {
                    return (Decimal) cRecord.get((String)cField.attributes.get('fieldName'));
                } else {
                    return 1;
                }
            } else {
                return 1;
            }
        } else {
            return 1;
        }
    }
        set;
    }

    public String progressLabel {get{
        if (cField.attributes.containsKey('useFieldValue')) {
            if (cField.attributes.get('useFieldValue')!=null) {
                if ((String)cField.attributes.get('useFieldValue')=='true') {
                    return '&nbsp;<b>' + String.valueOf(cRecord.get((String)cField.attributes.get('fieldName'))) + '%</b>';
                } else {
                    return '';
                }
            } else {
                return '';
            }
        } else {
            return '';
        }
    }
        set;
    }
}