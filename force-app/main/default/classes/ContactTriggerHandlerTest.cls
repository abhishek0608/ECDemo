@IsTest
private class ContactTriggerHandlerTest {

    @IsTest
    static void testHandleAfterInsert() {
        // Test data setup
        List<Contact> newList = new List<Contact>();
        Map<Id, Contact> oldMap = new Map<Id, Contact>();

        // Create test Accounts
        Account testAccount1 = new Account(Name = 'Test Account 1');
        Account testAccount2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{testAccount1, testAccount2};

        // Create test Contacts
        Contact testContact1 = new Contact(AccountId = testAccount1.Id , LastName = 'testContact1');
        Contact testContact2 = new Contact(AccountId = testAccount1.Id , LastName = 'testContact2');
        Contact testContact3 = new Contact(AccountId = testAccount2.Id , LastName = 'testContact3');
        Contact testContact4 = new Contact(LastName = 'testContact4'); // This contact won't have an AccountId
        newList.add(testContact1);
        newList.add(testContact2);
        newList.add(testContact3);
        newList.add(testContact4);
        Database.insert(newList);

        // Verify that AccountContactRole records were created for the Contacts with an AccountId
        List<AccountContactRole> insertedRecords = [SELECT Id, Role, AccountId, ContactId FROM AccountContactRole];
        System.assertEquals(2, insertedRecords.size()); // There should be 2 AccountContactRole records inserted
        System.assertEquals('Billing', insertedRecords[0].Role);
        System.assertEquals('Billing', insertedRecords[1].Role);
        System.assertEquals(testAccount1.Id, insertedRecords[0].AccountId);
        System.assertEquals(testAccount2.Id, insertedRecords[1].AccountId);
        System.assertEquals(testContact1.Id, insertedRecords[0].ContactId);
        System.assertEquals(testContact3.Id, insertedRecords[1].ContactId);
    }
}