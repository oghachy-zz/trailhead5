public with sharing class BAInsightConfiguration {

    public String BAInsightBaseUrl { get; set; }
    public String BAInsightPortalUrl { get; set; }
    private final BAInsightConfiguration__c instance;
    private ApexPages.StandardController con;   
    public String SelectedObject {get;set;}
    public String SelectedObjectField {get;set;}
    public String SelectedBAMapping {get;set;}
    
    public BAInsightConfiguration () {
    }
  
    public BAInsightConfiguration (ApexPages.StandardController stdController) {
        con = stdController;
        initialize();
    }
    
    public void initialize() {
        List<BAInsightConfiguration__c>items= new List<BAInsightConfiguration__c>();
        for (BAInsightConfiguration__c o : [select BA_Insight_Base_URL__c, BA_Insight_Portal_URL__c from BAInsightConfiguration__c limit 1]) {
            BAInsightBaseUrl = o.BA_Insight_Base_URL__c;
            BAInsightPortalUrl = o.BA_Insight_Portal_URL__c;
            break;
        }
    } 
    
    public static String getBAInsightBaseURLStatic() {
        BAInsightConfiguration obj = new BAInsightConfiguration ();
        obj.initialize();
        if(obj.BAInsightBaseUrl == null || obj.BAInsightBaseUrl == '')
            return '/apex/BAInsightConfiguration_VF';
        else
            return obj.BAInsightBaseUrl ;
    }

    public static String getBAInsightPortalURLStatic() {
        BAInsightConfiguration obj = new BAInsightConfiguration ();
        obj.initialize();
        if(obj.BAInsightPortalUrl == null || obj.BAInsightPortalUrl == '')
            return '';
        else
            return obj.BAInsightPortalUrl ;
    }
    
    public List<SelectOption> getObjects()
    {
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-- Select SalesForce Object --'));
        for(Schema.SObjectType f : gd)
        {
           options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getLabel()));
        }
        options.sort();
        return options;
    }
    
    public List<SelectOption> getObjectFields()
    {
        List<SelectOption> options = new List<SelectOption>();        
        Schema.SObjectType selected = null;
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();    
        for(Schema.SObjectType f : gd)
        {
            if(f.getDescribe().getName() == selectedObject)
                selected = f;
        }
        if(selected  != null) {
            Map<String, Schema.SObjectField> schemaFieldMap = selected.getDescribe().fields.getMap();
            for (String fieldName: schemaFieldMap.keySet()) {
                options.add(new SelectOption(fieldName, fieldName));  
            }
        }
        if(options.size() == 0) {
             options.add(new SelectOption('','-- Select Object Field --'));
        }
        options.sort();
        return options;
    }
    
    
    public List<BA_Insight_Field_Mapping__c> getMappings()
    {
        List<BA_Insight_Field_Mapping__c> aList = [select Id, BA_Salesforce_Object__c, BA_Salesforce_Object_Field_Name__c, BA_Insight_Field__c  from BA_Insight_Field_Mapping__c order by BA_Salesforce_Object__c limit 100];
        return aList;
    }
    
    public pagereference addMapping()
    {
            List<BA_Insight_Field_Mapping__c> aList = [select Id from BA_Insight_Field_Mapping__c where BA_Salesforce_Object__c = :SelectedObject and BA_Salesforce_Object_Field_Name__c = :SelectedObjectField];
            if(aList.size() == 0)
            {
                BA_Insight_Field_Mapping__c obj = new BA_Insight_Field_Mapping__c();
                obj.BA_Salesforce_Object__c = SelectedObject;
                obj.BA_Salesforce_Object_Field_Name__c = SelectedObjectField;
                obj.BA_Insight_Field__c = SelectedBAMapping;                
                insert obj; //create record in the database
            }
            else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Mapping for this Salesforce object and field exists, Please Delete and Add it again '));
            }        
    
        return null;
    }
    
    
    public PageReference save() {

        try {
            List<BAInsightConfiguration__c > aList = [select Id from BAInsightConfiguration__c limit 1];
            if(aList.size() == 0)
            {
                BAInsightConfiguration__c obj = new BAInsightConfiguration__c ();
                obj.BA_Insight_Base_URL__c = BAInsightBaseUrl;
                obj.BA_Insight_Portal_URL__c = BAInsightPortalUrl ;
                insert obj; //create record in the database
            }
            else {
                BAInsightConfiguration__c obj = aList.get(0);
                obj.BA_Insight_Base_URL__c = BAInsightBaseUrl ;
                obj.BA_Insight_Portal_URL__c = BAInsightPortalUrl ;
                update obj;
            }    
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'BA Insight configuration settings saved '));            
            return null;            
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error setting BA Insight Configuration Information '));
        }

        return null;
    }    
}