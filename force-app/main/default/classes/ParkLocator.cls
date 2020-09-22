public class ParkLocator
{
    public static String[] country(String param)
    {
        ParkService.ParksImplPort parkSymb = new ParkService.ParksImplPort();
        return  parkSymb.byCountry(param);
       
    }


}