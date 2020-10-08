/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
public class smdgEx {

    public static Boolean RaiseNew(Exception ex)
    {
        boolean raise = false;
        if (ex instanceof smdgException)
        {
            throw ex;
        }
        else
        {
            raise = true;
        }
        return raise;
    }
}