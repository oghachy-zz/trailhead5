@isTest (seeAllData=true)
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    static TestMethod void Product2Extension_UnitTest(){

            
            Integer initialSize=0;
            Integer secondSize=0;
            Product2 prod = new Product2();
            ApexPages.StandardController sc = new ApexPages.StandardController(prod);
            Product2Extension  ext = new Product2Extension(sc);

            PageReference pageRef = Page.Product2New;
            Test.setCurrentPage(pageRef);

                 
            System.assertEquals(ext.productsToInsert.size(),Constants.DEFAULT_ROWS );
            ext.addRows();
            System.assertEquals(ext.productsToInsert.size(),Constants.DEFAULT_ROWS*2 );

            for(Integer i = 0;i<5;i++)
            {
                Product2 prod2 = new Product2();
                prod2.Name = 'ProductX' + i;
                prod2.Family = Constants.PRODUCT_FAMILY[0].getValue();
                prod2.Initial_Inventory__c = 20;
                prod2.IsActive = true;

                Product2Extension.ProductWrapper prdoWrap  = ext.productsToInsert[i];
                PricebookEntry pricebookentry = new PricebookEntry(Product2Id=prod.Id,
                                                IsActive=true,
                                                Pricebook2Id=Constants.STANDARD_PRICEBOOK_ID,
                                                UnitPrice=10.0,
                                                UseStandardPrice=false);
               
                prdoWrap.productRecord=prod2;
                prdoWrap.pricebookEntryRecord=pricebookentry;
                //ext.productsToInsert[i]=prdoWrap;
            }

            Test.startTest();
            ext.save();
            Test.stopTest();
            ext.GetFamilyOptions();
            ext.GetInventory();

            System.assertEquals([Select Id from Product2 where Name Like 'ProductX%'].size(),5);
            //System.assertEquals([Select Id from pricebookEntry where UnitPrice=10.0 and IsActive=true and Pricebook2Id=:Constants.STANDARD_PRICEBOOK_ID].size(),5);
            
    }
    
      @isTest static void Product2Trigger_UnitTest(){

    Test.startTest();
    Product2 p = new Product2();
    p.Name = 'TestProduct';
    p.Family = 'Side';
    p.IsActive = true;
    p.Quantity_Ordered__c = 50;
    p.Initial_Inventory__c = 100;
    insert p;

    CollaborationGroup c = new CollaborationGroup();
    c.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
    c.Description = 'test';
    c.CollaborationType = 'Public';
    insert c;

    p.Quantity_Ordered__c=96;
    update p;
    List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
            ConnectApi.AnnouncementInput ann = new ConnectApi.AnnouncementInput();
            ann.expirationDate = System.now().addDays(1);
            ann.sendEmails = false;
            ann.parentId = c.Id;
            ann.body  = new ConnectApi.MessageBodyInput(); 
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            ann.body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            textSegmentInput.text = p.Name+' '+Constants.INVENTORY_LEVEL_LOW;
            ann.body.messageSegments.add(textSegmentInput);
            toPost.add(ann);
    AnnouncementQueueable.PostAnnouncements(toPost);
    Test.stopTest();
  }

 }