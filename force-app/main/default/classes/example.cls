global class example implements iterable<ConnectApi.ManagedContent>{
   global Iterator<ConnectApi.ManagedContent> Iterator(){
      return new CustomIterable();
   }
}