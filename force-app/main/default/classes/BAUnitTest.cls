@isTest
private class BAUnitTest {
    static testMethod void unitTestAll() {
        BAInsightConfiguration baConfig = new BAInsightConfiguration ();
        System.assert(BAInsightConfiguration.getBAInsightPortalURLStatic() != null);
        System.assert(BAInsightConfiguration.getBAInsightBaseURLStatic() != null);
        baConfig.BAInsightBaseUrl = 'http://www.google.com';
        baConfig.BAInsightPortalUrl = 'http://www.google.com';
        baConfig.save();
        baConfig.getObjects();
        baConfig.SelectedObject = 'Case';
        baConfig.getObjectFields();
        baConfig.SelectedObjectField  = 'subject';
        baConfig.addMapping();
        baConfig.SelectedObjectField  = 'product__c';
        baConfig.SelectedBAMapping = 'Product';
        baConfig.addMapping();
        System.assert(BAInsightConfiguration.getBAInsightPortalURLStatic() != null);
        System.assert(BAInsightConfiguration.getBAInsightBaseURLStatic() != null);
        
        Case cs = new Case();
        cs.subject = 'Connector Framework';
        insert cs;
        ApexPages.StandardController baCon = new ApexPages.StandardController(cs);              
        BAInsight ba = new BAInsight (baCon);
        ba.buildQuery('subject', '');
        ba.buildQuery('subject', 'Product');
        
        System.assert(ba.getBAInsightURL() != null);
        System.assert(ba.getBAInsightBaseURL () != null);
    }
}