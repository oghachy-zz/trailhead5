@RestResource(urlMapping='/Contacts/*')
global class AccountManager {

   @HttpGet 
   global static Account getAccount()
   {
       RestRequest req = RestContext.request;
       
       String idAcc = (req.requestURI.split('/'))[4];
       System.debug('### req.requesturi. '+req.requesturi);
       System.debug('### idAcc '+idAcc);
       Account acc = [Select Id,Name,(Select Id,Name from Contacts) from Account where Id = :idAcc];
       System.debug('#### acc '+acc);
       
       return acc;
   }
}