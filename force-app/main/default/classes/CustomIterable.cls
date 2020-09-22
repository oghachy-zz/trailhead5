global class CustomIterable 
   implements Iterator<ConnectApi.ManagedContent>{ 

   List<ConnectApi.ManagedContent> accs {get; set;} 
   Integer i {get; set;} 

   public CustomIterable(){ 
       accs = new List<ConnectApi.ManagedContent>();
   }   

   global boolean hasNext(){ 
       if(i >= accs.size()) {
           return false; 
       } else {
           return true; 
       }
   }    

   global ConnectApi.ManagedContent next(){ 

       if(i == 8){return null;} 
       i++; 
       return accs[i-1]; 
   } 
}