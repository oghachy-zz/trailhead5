public class AnimalLocator
{
        public static String getAnimalNameById(Integer x)
        {
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndPoint('https://th-apex-http-callout.herokuapp.com/animals/'+String.ValueOf(x));
                req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                req.setMethod('GET');
                HttpResponse resp = http.send(req);
                String res ='';
                if(resp.getStatusCode()!=201)
                {
                    Map<String,Object> mapStrObj = (Map<String,Object>)JSON.deserializeUntyped(resp.getBody());
  					for(String key:mapStrObj.keySet())
                    {
                        Map<String,Object> mapObj = (Map<String,Object>)mapStrObj.get(key);
                      
                        	res= (String)mapObj.get('name');
                    }
                }
                return res;
             
        }


}