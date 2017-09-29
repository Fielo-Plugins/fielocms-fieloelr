global class FieloCMSELR_CourseCategoryButton implements FieloPLT.ButtonActionInterface{
	
	public FieloPLT.RemoteActionResult executeAction(List<Id> recordIds, String parameters){
        FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();
        Savepoint sp = Database.setSavepoint();
        try{
            FieloCMSELR_CourseService.relateToCategories(new Set<Id>(recordIds));
            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage(ApexPages.SEVERITY.Info, 'success'));
            result.refresh.add(new FieloPLT.RemoteActionResult.RemoteActionRefresh(null, null));
            //result.addMessage(new RemoteActionResult.RemoteActionMessage(ApexPages.SEVERITY.Info, 'Edit executed'));
                    /*PageReference retPage = Page.FieloCMS__Page;
                    retPage.getParameters().put('pageId',component.RedirectPage__c);
                    retPage.getParameters().put(component.FieloCMS__DetailParameter__c,redemption.Id);
                    result.redirectURL = retPage.getUrl().replace('/apex','');*/
            /*}else if(button == 'clone'){
                result.addMessage(new RemoteActionResult.RemoteActionMessage(ApexPages.SEVERITY.Info, 'Clone executed'));
            }else{
                result.addMessage(new RemoteActionResult.RemoteActionMessage(ApexPages.SEVERITY.Info, 'else'));
            }*/
        }catch(Exception e){
            Database.rollback(sp);
            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage(ApexPages.SEVERITY.Error, e.getMessage()));
        }

        return result;
	}

}