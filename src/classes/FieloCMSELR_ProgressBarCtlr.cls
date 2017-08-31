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
}