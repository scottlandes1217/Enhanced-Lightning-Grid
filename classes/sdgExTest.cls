/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@istest
public class smdgExTest {
public  class NotsmdgException extends Exception {}

private static testmethod void RaiseNew()
    {
        Boolean NeedToRaiseNew = false;

        try
        {
            NeedToRaiseNew = smdgEx.raiseNew(new NotsmdgException('test'));

        }
        catch(Exception ex)
        {

        }
        system.assertEquals(true, NeedToRaiseNew, 'smdgEx:RaiseNewTrue: Expected to be told to raise smdgException');
    }
    private static testmethod void RaiseNew2()
    {
        Boolean isError = false;

        try
        {
            smdgEx.raiseNew(new smdgException('test'));

        }
        catch(Exception ex)
        {

                if (ex instanceof smdgException)
                    isError = true;
        }
        system.assertEquals(true, isError, 'smdgEx:RaiseNewTrue: Expected smdgException');
    }
}