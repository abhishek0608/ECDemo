public class ContactTriggerHandler {
    // Method to handle logic after new contact records are inserted
    public static void handleAfterInsert(List<contact> newList , Map<ID , contact> oldMap){
        Map<Id , contact> acountIdAndContactMap = new Map<Id , contact>();
        For(contact con  :  newList){
            if(con.AccountId != Null){
                if(!acountIdAndContactMap.containsKey(con.AccountId)){
                    acountIdAndContactMap.put(con.AccountId , con);
                }
            }
        }
        
        // Query for existing AccountContactRole records related to the contacts in the map
    	Map<ID , AccountContactRole> existingAccountsRoleMap = new Map<ID , AccountContactRole>([SELECT ID FROM AccountContactRole 
                                                             										WHERE ID IN :acountIdAndContactMap.keySet()]);
    
    	List<AccountContactRole> newRecordToBeInserted = new List<AccountContactRole>();
    	for(Id accId : acountIdAndContactMap.keySet()){
            // Check if there is no existing AccountContactRole record for this AccountId
            if(!existingAccountsRoleMap.containsKey(accId)){
                AccountContactRole acr = new AccountContactRole();
                acr.Role = 'Billing';
                acr.AccountId = accId;
                acr.ContactId = acountIdAndContactMap.get(accId).Id;
                newRecordToBeInserted.add(acr);
            }
    	}
    	Database.insert(newRecordToBeInserted);
    }
}