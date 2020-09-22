@isTest
private class LeadProcessorTest {

    @isTest
    static void cover()
    {
        Lead  l = new Lead(LastName='Test',LeadSource='');
        insert l;
        
        Test.startTest();
        
        LeadProcessor leadproc = new LeadProcessor();
        
        Id batchId = Database.executeBatch(leadproc);
        
        Test.stopTest();
    }
    
}