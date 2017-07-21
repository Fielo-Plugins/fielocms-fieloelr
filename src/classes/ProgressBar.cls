public class ProgressBar implements FieloCMS.ViewSubComponentInterface {
    public ApexPages.Component getSubComponent(FieloCMS.Field field, SObject record){
    	system.debug(field);
    	system.debug(record);
        Component.ProgressBar progress = new Component.ProgressBar();
        return progress;
    }
}