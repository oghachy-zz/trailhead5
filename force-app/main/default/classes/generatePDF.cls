@RestResource(urlMapping='/generateDocs/*')
global  with sharing class generatePDF {
@HttpPost
global static String createPDF(String contentPDF,String NamePdf)
{
    Blob body = EncodingUtil.base64Decode(contentPDF);
    Attachment attchRecord = new Attachment();
    attchRecord.Body = body;
    attchRecord.Name = NamePdf+'.pdf';
    attchRecord.isPrivate = false;
    attchRecord.ParentId  = [Select Id from Account order by Name limit 1].Id;
    insert attchRecord;
    return attchRecord.Id;
}
    
@HttpGet
global static String sendPDF()
{
    RestRequest request = RestContext.request;
    String idDocument = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
    List<Attachment> lstAttachment = [Select Body from Attachment where Id=:idDocument];
    return (!lstAttachment.isEmpty() ? EncodingUtil.base64Encode(lstAttachment[0].Body) : '');
}    
    
}