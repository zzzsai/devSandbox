trigger onDeleteEstimate on Release_Estimation__c (before delete)
{
   List<Id> reqId = new List<Id>();
   List<Id> reqEstId = new List<Id>();
   List<Requirements_Selected__c> reqSelDelList = new List<Requirements_Selected__c>();
   List<Requirement_Estimation__c> checkReqDetails= new List<Requirement_Estimation__c>();
   List<Requirement__c> reqToUpdate= new List<Requirement__c>();
   List<Release_Estimation__c> estToDel= new List<Release_Estimation__c>();
   
   for(Release_Estimation__c estimate:Trigger.old)
   {
       estToDel.add(estimate);
       reqEstId.add(estimate.id);
   }  
   
   checkReqDetails=[Select id,p.Requirement_id__c from Requirement_Estimation__c p where p.ReleaseEstimation__c IN:reqEstId];
  
   for(Requirement_Estimation__c checkedReq1:checkReqDetails)
   {
       reqId.add(checkedReq1.id);
   }
   reqSelDelList =[Select p.Capacity_Id__c from Requirements_Selected__c p where p.Requirement_Id__c In :reqId]; 
 
   if(reqSelDelList.size()>0)
   { 
       for(Release_Estimation__c estToDel1:estToDel)
       {
           Trigger.oldMap.get(estToDel1.id).addError('Estimate cannot be deleted as its requirements are associated to a capacity');    
       }
       
   }
   else
   {
       for(Requirement_Estimation__c checkedReq:checkReqDetails)
       {
           Requirement__c delReq = new Requirement__c(id=checkedReq.Requirement_id__c, is_Selected__c=false);                      
           reqToUpdate.add(delReq);
       }
       update reqToUpdate;
       
   }
    
}