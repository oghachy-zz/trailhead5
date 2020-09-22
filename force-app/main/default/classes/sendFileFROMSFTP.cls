@RestResource(urlMapping='/sendFileFROMSFTP/*')
global  with sharing class sendFileFROMSFTP{
@HttpPost
global static void sendFile()
{
RestRequest req= RestContext.request;
Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(req.requestBody.ToString());  
String idRecord = String.valueOf(responseMap.get('parentId'));
String b = EncodingUtil.base64Encode([Select VersionData from ContentVersion Where ContentDocumentId='0690N000006Bv8O'].VersionData);

asy.sendAsy(b);
 

}
}