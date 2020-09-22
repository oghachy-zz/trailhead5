/**
 * @name OrderExtension
 * @description This class is provided for you to facilitate the Super Badge
**/
public class OrderExtension {

    public Order orderRecord {get;set;}
    public List<OrderItem> orderItemList {get;set;}
    public String selectedFamily {get;set;}
    public List<chartHelper.chartData> pieData {get;set;}
    public Decimal total {get;set;}

    public Map<Id,OrderItem> orderItemMap;
    ApexPages.StandardSetController standardSetController;

    public OrderExtension(ApexPages.StandardController standardController){
        orderRecord = (Order)standardController.getRecord();
        orderItemMap = new Map<id,OrderItem>();
        if ( orderRecord.Id != null ){
            orderRecord = queryOrderRecord(orderRecord.Id);
        }


        for(OrderItem ordIt:orderRecord.orderItems)
        {
            orderItemMap.put(ordIt.PricebookEntryId,ordIt);
        }
        total=0;
        refreshStandardSetController();

        
        pieData = new List<chartHelper.chartData>();
        Map<String,Decimal> mapProd = new Map<String,Decimal>();

        for(OrderItem ord:orderRecord.orderItems)
        {
            //chartHelper.chartData ch = new  chartHelper.chartData( ord.PricebookEntry.Name,ord.Quantity);
            //pieData.add(ch);
            if(mapProd.get(ord.PricebookEntry.Name)==null)
            {
                mapProd.put(ord.PricebookEntry.Name,0);
            }

            mapProd.put(ord.PricebookEntry.Name,mapProd.get(ord.PricebookEntry.Name)+(ord.Quantity*ord.UnitPrice));
        }

        for(String prod:mapProd.keySet())
        {
           chartHelper.chartData ch = new  chartHelper.chartData( prod,mapProd.get(prod)); 
           pieData.add(ch);
        }
        
        buildOrderItemList();
    }

    //ToDo: Implement your own method to populate orderItemList
    //  that you will call after pagination and/or family selection

    public void  buildOrderItemList()
    {
        orderItemList = new List<OrderItem>();

        for(PricebookEntry pr:(List<PricebookEntry>)standardSetController.getRecords())
        {
            if(!orderItemMap.containsKey(pr.Id))
            {
                OrderItem ordItem = new OrderItem();
                ordItem.Quantity = 0;
                ordItem.UnitPrice = pr.UnitPrice;
                ordItem.Product2 = pr.product2;
                ordItem.PricebookEntryId = pr.Id;
                orderItemList.add(ordItem);
                orderItemMap.put(pr.Id,ordItem);
            }
            else
            {
                orderItemList.add(orderItemMap.get(pr.Id));
            }
        }
    }

    /**
     * @name OnFieldChange
     * @description
    **/
    public void OnFieldChange(){
        //ToDo: Implement logic to store the values changed on the page
        //      and populate pieData
        //      and populate total
        pieData = new List<chartHelper.chartData>();
        Map<String,Decimal> mapProd = new Map<String,Decimal>();
        total = 0;

        for(OrderItem ord:orderRecord.orderItems)
        {
            //chartHelper.chartData ch = new  chartHelper.chartData( ord.PricebookEntry.Name,ord.Quantity);
            //pieData.add(ch);
            if(mapProd.get(ord.PricebookEntry.Name)==null)
            {
                mapProd.put(ord.PricebookEntry.Name,0);
            }

            mapProd.put(ord.PricebookEntry.Name,mapProd.get(ord.PricebookEntry.Name)+(ord.Quantity*ord.UnitPrice));
        }

        for(String prod:mapProd.keySet())
        {
           chartHelper.chartData ch = new  chartHelper.chartData( prod,mapProd.get(prod)); 
           pieData.add(ch);
        }

    }

    /**
     * @name SelectFamily
     * @description
    **/
    public void SelectFamily(){
        //ToDo: Implement logic to filter based on the selected product family
        refreshStandardSetController();
        buildOrderItemList();
    }

  void refreshStandardSetController(){
    String query = 'SELECT Name, Product2.Family, Product2.Name, Product2Id, UnitPrice, Product2.Quantity_Remaining__c FROM PricebookEntry WHERE IsActive = TRUE';

    if(selectedFamily != null && selectedFamily != Constants.SELECT_ONE) {
      query += ' AND Product2.Family = \'' + selectedFamily + '\'';
    }
    query += ' ORDER BY Name';

    standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
    standardSetController.setPageSize(Constants.DEFAULT_ROWS);
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

    /**
     * @name Save
     * @description
    **/
    public void Save(){
        //ToDo: Implement logic to save the Order and populated OrderItems
        List<OrderItem> lstOrderItem2Save = new List<OrderItem>();
        List<OrderItem> lstOrderItem2Delete = new List<OrderItem>();
        Savepoint sp = Database.setSavepoint();
        try
        {        
            if(orderRecord.Pricebook2Id == null) {
                orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            }
                upsert orderRecord;
        for(OrderItem ordit:orderItemList)
        {
            if(ordit.Quantity>0)
            {
                if(ordit.OrderId==null)
                {
                    ordit.OrderId=orderRecord.Id;
                    lstOrderItem2Save.add(ordit);
                }
            }
            else
            {
                if(ordit.Id!=null)
                {
                    lstOrderItem2Delete.add(ordit);
                }
            }
        }


            if(lstOrderItem2Save.size()>0)
            {
                upsert lstOrderItem2Save;
            }
            if(lstOrderItem2Delete.size()>0)
            {
                delete lstOrderItem2Delete;
            }
        }   
        catch(Exception e)
        {
           Database.rollback( sp );
           apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,Constants.ERROR_MESSAGE)); 
        }
        OnFieldChange();
    }


    /**
     * @name First
     * @description
    **/
    public void First(){
         standardSetController.first();
         buildOrderItemList();
    }


    /**
     * @name Next
     * @description
    **/
    public void Next(){
         standardSetController.next();
         buildOrderItemList();
    }


    /**
     * @name Previous
     * @description
    **/
    public void Previous(){
         standardSetController.previous();
         buildOrderItemList();
    }

    /**
     * @name Last
     * @description
    **/
    public void Last(){
         standardSetController.last();
         buildOrderItemList();
    }

    /**
     * @name GetHasPrevious
     * @description
    **/
    public Boolean GetHasPrevious(){
        return standardSetController.getHasPrevious();
    }

    /**
     * @name GetHasNext
     * @description
    **/
    public Boolean GetHasNext(){
        return standardSetController.getHasNext();
    }

    /**
     * @name GetTotalPages
     * @description
    **/
    public Integer GetTotalPages(){
    return (Integer)Math.ceil(standardSetController.getResultSize() / (Decimal)Constants.DEFAULT_ROWS);
    }

    /**
     * @name GetPageNumber
     * @description
    **/
    public Integer GetPageNumber(){
        return standardSetController.getPageNumber();
    }

    /**
     * @name QueryOrderRecord
     * @description
    **/
    public static Order QueryOrderRecord(Id orderId){
        return [
            SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id,
                (
                    SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id,
                         Product2.Name, Product2.Family, Product2.Quantity_Remaining__c,
                         PricebookEntry.Name
                    FROM OrderItems
                )
            FROM Order
            WHERE Id = :orderId
        ];
    }

}