public with sharing class BAInsight {

    public String query {get; set;}
    public String redirectUrl {public get; private set;}
    public transient ApexPages.Component scriptComponent { get; private set; }

    public BAInsight(ApexPages.StandardController controller) {
        redirectUrl = controller.view().getUrl();
        SObject obj = controller.getRecord();
        String objectName = obj.getSObjectType().getDescribe().getName();
        String Id = obj.Id;
        List<BA_Insight_Field_Mapping__c> mappings = [select BA_Salesforce_Object__c,BA_Salesforce_Object_Field_Name__c,BA_Insight_Field__c from BA_Insight_Field_Mapping__c where BA_Salesforce_Object__c = :objectName];
        
        String query = 'select ';
        for(BA_Insight_Field_Mapping__c map1 : mappings) {
            query = query + map1.BA_Salesforce_Object_Field_Name__c + ',';                        
        }
        query = query + 'Id from ' + objectName + ' where Id = :Id';
        
        SObject loadedObject = Database.query(query);
        
        for(BA_Insight_Field_Mapping__c map1 : mappings) {
            if(loadedObject.get(map1.BA_Salesforce_Object_Field_Name__c) != null)            
                buildQuery((String.valueOf(loadedObject.get(map1.BA_Salesforce_Object_Field_Name__c))), map1.BA_Insight_Field__c);
        }
    }
    
    public String buildQuery(String field, String field2)
    {
        if(query == null || query.length() == 0)
        {
            if(field2 == null || field2.length() == 0)           
                return query = field;        
            else
                return query = field2 + ':"' + field + '"';
        }
        else if(field == null || field.length() == 0)
            return '';
        else {
            if(field2 == null || field2.length() == 0)           
                return query += ' AND ' + field;        
            else
                return query += ' AND ' + field2 + ':"' + field + '"';  
        }
    }

    
    public String getBAInsightURL() {

        return BAInsightConfiguration.getBAInsightBaseURLStatic() + '?SalesForceBA=' + URL.getSalesforceBaseUrl().toExternalForm() + '&k=' + query;

    }
    
    public String getBAInsightBaseURL () { 
    
        return BAInsightConfiguration.getBAInsightBaseURLStatic() + '?k=' + query;
    
    }
    
    public String getBAInsightQuery () { 
    
        return '?k=' + query;
    
    }

}