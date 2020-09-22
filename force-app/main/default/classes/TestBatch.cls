global class TestBatch implements Database.batchable<ConnectApi.ManagedContent>{
 global Iterable<ConnectApi.ManagedContent> start(Database.batchableContext info){ 
       return new example(); 
   }     
   global void execute(Database.batchableContext info, List<ConnectApi.ManagedContent> scope){ 

   }     
   global void finish(Database.batchableContext info){     
   } 
}