global class FieloCMSELR_CourseCategoryButton implements FieloPLT.ButtonActionInterface{
	
	public FieloPLT.RemoteActionResult executeAction(List<Id> recordIds, String parameters){
        FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();
        Savepoint sp = Database.setSavepoint();
        try{
            FieloCMSELR_CourseService.relateToCategories(new Set<Id>(recordIds));
            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage(ApexPages.SEVERITY.Info, 'Content Enabled'));
            result.redirectUrl = 'reload';
        }catch(Exception e){
            Database.rollback(sp);
            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage(ApexPages.SEVERITY.Error, e.getMessage()));
        }

        return result;
	}

}