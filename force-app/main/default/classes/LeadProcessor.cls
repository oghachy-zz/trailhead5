global class LeadProcessor implements Database.Batchable<sObject>{

     global Database.QueryLocator start(Database.BatchableContext bc) {
         
         return database.getqueryLocator('Select Id,LeadSource from Lead limit 200');
     }
    
     global void execute(Database.BatchableContext bc, List<Lead> scope){
         
         for(Lead thelead:scope)
         {
             thelead.LeadSource = 'Dreamforce';
         }
         
         update scope;
     }
    
     global void finish(Database.BatchableContext bc){
         
     }
}