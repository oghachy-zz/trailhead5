trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {

    List<BatchLeadConvertErrors__c> lst = new List<BatchLeadConvertErrors__c>();
	
    for(BatchApexErrorEvent  bcl:Trigger.new){
        BatchLeadConvertErrors__c bc = new BatchLeadConvertErrors__c();
        bc.AsyncApexJobId__c  = bcl.AsyncApexJobId ;
        bc.Records__c  = bcl.JobScope ;
        bc.StackTrace__c  = bcl.StackTrace ; 
        lst.add(bc);
    }
	
    if(!lst.isEmpty()){
        insert lst;
    }
    
}