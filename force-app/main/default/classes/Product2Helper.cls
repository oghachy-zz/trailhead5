public class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name = :Constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST'+Constants.INVENTORY_ANNOUNCEMENTS)

        LIMIT 1
    ];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void AfterUpdate(List<Product2> newList, List<Product2> oldList){
        //ToDo: Declare a List of Product2 records named needsAnnouncement
        List<Product2> lstProd = new List<Product2>();
        //ToDo: Declare a Map of Strings to Inventory_Setting__mdt records
        Map<String,Inventory_Setting__mdt> mapInventorySett = new Map<String,Inventory_Setting__mdt>();
        //ToDo: Loop through a query of Inventory_Setting__mdt records and populate the Map with Name as the key
        for(Inventory_Setting__mdt invt:[Select DeveloperName,Low_Quantity_Alert__c from Inventory_Setting__mdt])
        {
            mapInventorySett.put(invt.DeveloperName,invt);
        }
        //ToDo: Loop through the Products in newList

        for(Product2 newprod:newList)
        {
            if(mapInventorySett.get(newprod.Family)!=null)
            {
                System.debug('newprod.Quantity_Remaining__c '+newprod.Quantity_Remaining__c);
                System.debug('mapInventorySett.get(newprod.Family).Low_Quantity_Alert__c '+mapInventorySett.get(newprod.Family).Low_Quantity_Alert__c);
                if(newprod.Quantity_Remaining__c <= mapInventorySett.get(newprod.Family).Low_Quantity_Alert__c)
                {
                    lstProd.add(newprod);
                }
            }
        }
        // Use the corresponding Inventory Setting record to determine the correct Low Quantity Alert
        // If the Product's Quantity Remaining has been changed to less than the Low Quantity Alert
        //      add it to the needsAnnouncement list

        //ToDo: Pass records to the postAlerts method
        if(lstProd.size()>0)
        {
            PostAlerts(lstProd);
        }
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void PostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            // ToDo: Construct a new AnnouncementInput for the Chatter Group so that it:
            // expires in a day
            // does not notify users via email.
            // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant
            ConnectApi.AnnouncementInput ann = new ConnectApi.AnnouncementInput();
            ann.expirationDate = System.now().addDays(1);
            ann.sendEmails = false;
            ann.parentId = COLLABORATION_GROUP[0].Id;
            ann.body  = new ConnectApi.MessageBodyInput(); 
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            ann.body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            textSegmentInput.text = p.Name+' '+Constants.INVENTORY_LEVEL_LOW;
            ann.body.messageSegments.add(textSegmentInput);

            toPost.add(ann);
        }
        
        AnnouncementQueueable n = new AnnouncementQueueable();
        n.toPost = toPost;
        System.enqueueJob(n);

        //AnnouncementQueueable.PostAnnouncements(toPost);
        // ToDo: Create and enqueue an instance of the announcementQueuable class with the list of Products
    }
}