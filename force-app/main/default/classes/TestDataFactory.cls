/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public  static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup cg = new CollaborationGroup(
        Name = 'TEST'+Constants.INVENTORY_ANNOUNCEMENTS,
        CollaborationType = 'Public'
        );

        return cg;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        
        List<Product2> lstProd = new List<Product2>();
        
        List<Schema.PicklistEntry> lstFamily = Constants.PRODUCT_FAMILY;
    for (Integer i = 0; i < cnt; i++) {
      Product2 p = new Product2();
      p.Name = 'Product ' + i;
      p.Family = lstFamily[Math.mod(i, lstFamily.size())].getValue();
      p.Initial_Inventory__c = 10;
      p.IsActive = true;
      lstProd.add(p);
    }
        /*
        for(Schema.PicklistEntry pk:Constants.PRODUCT_FAMILY)
        {
            i++;
            Product2 prod = new Product2(
            Name= String.valueOf(i)+'Test',
            Family=pk.getValue(),
            Initial_Inventory__c=10,
            IsActive=true,
            ProductCode='123'
            );
            lstProd.add(prod);
        }
        */
        return lstProd;

    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        System.debug('### prods '+prods);
        List<PricebookEntry> lstProdEntry = new List<PricebookEntry>();
        Id STANDARD_PRICEBOOK_ID = Constants.STANDARD_PRICEBOOK_ID;
        for(Product2 prod:prods)
        {
            PricebookEntry pricebookentry = new PricebookEntry(Product2Id=prod.Id,
                                                IsActive=true,
                                                Pricebook2Id=STANDARD_PRICEBOOK_ID,
                                                UnitPrice=10.0,
                                                UseStandardPrice=false);
            lstProdEntry.add(pricebookentry);
        }

        System.debug(lstProdEntry);
        return lstProdEntry;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        
        List<Account> lstAccount = new List<Account>();

        for(Integer i=0;i<cnt;i++)
        {
            Account acc = new Account(Name='Test'+String.valueOf(i));
            lstAccount.add(acc);
        }

        return lstAccount;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> lstContact = new List<Contact>();

        for (Integer i = 0; i < cnt; i++) {
        
        Contact c = new Contact();
        c.LastName = 'Contact ' + i;
        c.AccountId = accts[Math.mod(i, accts.size())].Id;
        
        lstContact.add(c);
        }


        return lstContact;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        
        List<Order> lstOrder = new List<Order>();
    for (Integer i = 0; i < cnt; i++) {
      Order o = new Order();
      o.Name = 'Order ' + i;
      o.AccountId = accts[Math.mod(i, accts.size())].Id;
      o.EffectiveDate = Date.today();
      o.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
      o.Status = 'Draft';
      lstOrder.add(o);
    }
        return lstOrder;

    }

    /** 
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        
        List<OrderItem> lstOrderItem = new List<OrderItem>();

    for (Integer i = 0; i < cnt; i++) {
      OrderItem oi = new OrderItem();
      oi.OrderId = ords[Math.mod(i, ords.size())].Id;
      oi.PriceBookEntryId = pbes[Math.mod(i, pbes.size())].Id;
      oi.Quantity = Constants.DEFAULT_ROWS;
      oi.UnitPrice = 1;
      lstOrderItem.add(oi);
    }

        return lstOrderItem;

    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.

        insert ConstructCollaborationGroup();
        List<Account> lstAcc = ConstructAccounts(cnt);
        insert lstAcc;
        System.debug('#### lstAcc '+lstAcc.size());
        System.debug('#### cnt '+cnt);
        List<Product2> lstProd = ConstructProducts(cnt);
        insert lstProd;
        List<PricebookEntry> lstPriceBookEntrt = ConstructPricebookEntries(lstProd);
        insert lstPriceBookEntrt;
        insert ConstructContacts(cnt,lstAcc);              
        List<Order> lstOrder = ConstructOrders(cnt,lstAcc);
        insert lstOrder;
        insert ConstructOrderItems(cnt,lstPriceBookEntrt,lstOrder);
         
    }

    public static  void  VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered)
    {
        
        System.assertEquals(updatedProduct.Quantity_Ordered__c, (originalProduct.Quantity_Ordered__c + qtyOrdered));

       
        //System.assertEquals(updatedProduct.Quantity_Ordered__c+originalProduct.Quantity_Ordered__c,qtyOrdered);
    }


}