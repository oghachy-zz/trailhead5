public class send22SFTP{


@future(callout=true)
public static void sendFile(){

        http http = new Http();
        HttpRequest request = new HttpRequest();
        String body ='{"ContentLocation" : "S", "Title" : "donwload.jpg","PathOnClient" : "C//0019E00000meOXG/0019E00000oQ2jZ/download.jpg","VersionData" : "$body$","R0_File_Property_Id__c" : "a4y9E00000019UC"}';
        
        request.setEndpoint('https://inwi-dev-sandbox--dev.cs88.my.salesforce.com/services/data/v43.0/sobjects/ContentVersion');
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json');
        body = body.replace('$body$',EncodingUtil.base64Encode([SELECT VersionData FROM ContentVersion WHERE Id='0680N000006QUSXQA4'].VersionData));
        request.setBody(body);
        request.setHeader('Authorization', 'OAuth 00D9E0000001HDy!ARUAQDYFMra3qU7lF7_YEs13Y0ZfqZllj0e8Phs9df6V_imu9ZcAWYGanSgm.sjehBYOgwgB5nlvChTWvF1dJKEu31VgO.l8');
        HttpResponse res = http.send(request); 
        String UrlDocument = res.getBody();
        System.debug('UrlDocument '+UrlDocument );
        

}

}