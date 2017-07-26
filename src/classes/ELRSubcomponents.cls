public with sharing class ELRSubcomponents {
    public class ProgressBar implements FieloCMS.ViewSubComponentInterface {
    	public ApexPages.Component getSubComponent(FieloCMS.Field field, SObject record){
            system.debug('ProgressBar');
            system.debug(field);
            system.debug(record);
            Component.Widget1 progress = new Component.Widget1();
            if(record != null){
                progress.record = record;
            }else{
                progress.expressions.record = '{!record}';
            }
            progress.field = field;
            return progress;
        }
    }

    public class CourseAction implements FieloCMS.ViewSubComponentInterface {
        public ApexPages.Component getSubComponent(FieloCMS.Field field, SObject record){
            system.debug('Course Action');
            system.debug(field);
            system.debug(record);
            Component.Widget2 action = new Component.Widget2();
            
            return action;
        }
    }
}