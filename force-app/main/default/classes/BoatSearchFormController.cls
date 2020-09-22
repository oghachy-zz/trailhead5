public class BoatSearchFormController {

    @AuraEnabled
    public static BoatType__c[] retrieveBoatTypes()
    {
        return [Select Id,Name from BoatType__c ];

    }
    
    @AuraEnabled
    public static boolean createBoat(String idBoatType)
    {
        Boat__c boat = new Boat__c(BoatType__c=idBoatType);
        
        try
        {
            insert boat;
            return true;
        }
        catch(Exception e)
        {
            return false;
        }
        
    }
    
}