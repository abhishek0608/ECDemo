trigger contactTrigger on contact (after insert) {
    If(Trigger.isAfter && Trigger.isInsert){
        ContactTriggerHandler.handleAfterInsert(Trigger.New , Trigger.oldMap);
    }
}