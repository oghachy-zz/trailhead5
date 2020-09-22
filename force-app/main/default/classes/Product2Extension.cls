public class Product2Extension {

    //public List<Product2> productsToInsert {get;set;}
    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController stdController){
        //productsToInsert = new List<Product2>();
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            //productsToInsert.add( new Product2() );
            productsToInsert.add( new ProductWrapper() );
        }
        
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public PageReference Save(){
            Savepoint sp = Database.setSavepoint();
        try {

            List<PriceBookEntry> lstPriceBook2Insert = new List<PriceBookEntry>();
            List<Product2> lstProd2Insert = new List<Product2>();
            for(ProductWrapper prod:productsToInsert)
            {
                if(prod.productRecord!=null && prod.pricebookEntryRecord!=null)
                {
                    if( prod.productRecord.Name!=null 
                        //&&prod.productRecord.Family!=null
                        && prod.pricebookEntryRecord.isActive!=null 
                        && prod.pricebookEntryRecord.UnitPrice!=null 
                        && prod.productRecord.Initial_Inventory__c!=null
                        &&constants.SELECT_ONE!=prod.productRecord.Family)
                    {
                        prod.pricebookEntryRecord.Pricebook2Id =Constants.STANDARD_PRICEBOOK_ID;
                        prod.pricebookEntryRecord.Product2Id =prod.productRecord.Id;
                        //prod.pricebookEntryRecord.isActive = true;
                        lstProd2Insert.add(prod.productRecord);
                        lstPriceBook2Insert.add(prod.pricebookEntryRecord);
                    }
                }
            }
            //insert productsToInsert;
            
            try
            {
                if(lstProd2Insert.size()>0)
                {
                    insert lstProd2Insert;
                    //insert lstPriceBook2Insert;
                    for(Integer i=0;i<lstProd2Insert.size();i++)
                    {
                        lstPriceBook2Insert[i].Product2Id = lstProd2Insert[i].Id;
                    }
                    insert lstPriceBook2Insert;
                }
                lstPriceBook2Insert.clear();
                 apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            }
            catch(Exception e)
            {
                Database.rollback( sp );
                apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,Constants.ERROR_MESSAGE));
            }


            //If successful clear the list and display an informational message
            
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){

        }
        return null;
    }

    public List<SelectOption> GetFamilyOptions()
    {
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(Constants.SELECT_ONE,Constants.SELECT_ONE));
       for(Schema.PicklistEntry pentry:Constants.PRODUCT_FAMILY)
       {
            options.add(new SelectOption(pentry.getValue(),pentry.getLabel()));
       }

       return options; 
    }

    public class ProductWrapper{
        public Product2 productRecord {get;set;}
        public PriceBookEntry pricebookEntryRecord {get;set;}
        public ProductWrapper()
        {
            productRecord = new Product2();
            pricebookEntryRecord = new PriceBookEntry();
        }

    }

}