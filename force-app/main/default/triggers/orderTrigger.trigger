/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (
 after update

) {   
    orderHelper.AfterUpdate(Trigger.new,Trigger.old);

}