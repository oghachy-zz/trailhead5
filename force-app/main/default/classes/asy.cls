public class asy{

@future(Callout=true)
public static void sendAsy(String stBody){
String token ='00D9E0000001HDy!ARUAQMDLJuF8l8y5Aa66PlkAK6rV0Mz.x_jEhY5eIOrOUjFspLbWV_FGZuDErL4E05_KU3KvcVYmLy5kG_ASjrLkSVAlr8TH';
Http http = new Http();

HttpRequest request = new HttpRequest();
request.setEndpoint('https://inwi-dev-sandbox--dev.cs88.my.salesforce.com/services/data/v43.0/sobjects/ContentVersion');
request.setMethod('POST');
request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        //request.setHeader('Accept-Encoding', 'gzip');
request.setHeader('Authorization', 'OAuth '+token);
String bodyInsert='{"ContentLocation":"S","VersionData":"'+stBody+'","Title":"fromSFTP.ppt","PathOnClient":"fromSFTP.ppt"}';
request.setBody(bodyInsert);
HttpResponse res = http.send(request);

System.debug(res.getBody());
}

}