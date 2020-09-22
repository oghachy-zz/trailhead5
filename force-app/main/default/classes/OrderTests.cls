@isTest 
private class OrderTests {

    @testSetup static void SetupTestData () {
        // Create common test accounts
		TestDataFactory.InsertTestData(1);      
    }

    @isTest static void OrderUpdate_UnitTest() {
    	Test.startTest();
    	Order ord = [Select Id,Status from Order limit 1];
    	Product2 prod1 = [Select Id,Initial_Inventory__c,Quantity_Ordered__c from Product2 limit 1];
    	ord.Status = constants.ACTIVATED_ORDER_STATUS;
    	update ord;
    	Product2 prod2 = [Select Id,Initial_Inventory__c,Quantity_Ordered__c from Product2 limit 1];
    	
    	TestDataFactory.VerifyQuantityOrdered(prod1,prod2,constants.DEFAULT_ROWS);
    	Test.stopTest();
    }

  @isTest static void OrderExtension_UnitTest() {
    PageReference pageRef = Page.OrderEdit;
    Test.setCurrentPage(pageRef);
    Order o = [SELECT Id, Status FROM Order LIMIT 1];
    ApexPages.StandardController stdcontroller = new ApexPages.StandardController(o);
    OrderExtension ext = new OrderExtension(stdcontroller);
    
    ext.OnFieldChange();
    ext.SelectFamily();
    ext.Save();
    ext.First();
    ext.Next();
    ext.Previous();
    ext.Last();
    ext.GetHasPrevious();
    ext.GetHasNext();
    ext.GetTotalPages();
    ext.GetPageNumber();
    List<SelectOption> options = ext.GetFamilyOptions();
  }    

}