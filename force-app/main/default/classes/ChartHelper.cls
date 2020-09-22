public without sharing class ChartHelper {

    @AuraEnabled
    public static List<chartData> GetInventory(){
        List<chartData> cht = new List<chartData>();
        //ToDo: Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c
        for(AggregateResult prod:[Select Family fml,sum(Quantity_Remaining__c) qte from Product2 where Quantity_Remaining__c>0 group by Family])
        {
            cht.add(new ChartData(String.valueOf(prod.get('fml')),(Decimal)(prod.get('qte'))));
        }
        //  And return a list of chartData
        //  Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
        return cht;
    }

    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }

}