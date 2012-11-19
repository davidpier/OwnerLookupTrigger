/*
Description : Test class for LeadOwnerLookup Trigger
*/ 

@isTest
public class Test_LeadOwnerLookupTrigger {
        
    static testMethod void myUnitTest() {
        //Create a test lead
        Lead ld = new Lead(
            Name = 'Test Lead'
        );
        insert ld;
        //Assert that Owner_Lookup__c = OwnerId
        System.assertEquals(ld.OwnerId, ld.Owner_Lookup__c);

        //Create a test user
        list<Profile> p1 = [SELECT Id FROM Profile WHERE Name like 'System Administrator'];
        
        User u1 = new User();
            u1.FirstName = 'First';
            u1.LastName = 'Last';
            u1.Email = 'test@test.com';
            u1.Username = 'test@test.com';
            u1.Alias ='test';
            u1.CommunityNickname = 'test';
            u1.TimeZoneSidKey ='America/New_York';
            u1.LocaleSidKey = 'en_US';
            u1.EmailEncodingKey = 'UTF-8';
            u1.ProfileId = p1[0].id;
            u1.LanguageLocaleKey = 'en_US';
            u1.Country = 'United Kingdom';
        insert u1;
        
        //Update OwnerId
        ld.OwnerId = u1.Id;
        update ld;
        ld = [select Id,OwnerId,Owner_Lookup__c from Lead where Id = :ld.Id limit 1];
        //Assert that Owner_Lookup__c = OwnerId
        System.assertEquals(ld.OwnerId, ld.Owner_Lookup__c);
    }

    static testMethod void myUnitTestBulk() {
        List<Lead> leads = new List<Lead>();
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];

        User u2 = new User();
            u2.FirstName = 'FirstName';
            u2.LastName = 'LastName';
            u2.Email = 'test2@test.com';
            u2.Username = 'test2@test.com';
            u2.Alias ='test2';
            u2.CommunityNickname = 'test2';
            u2.TimeZoneSidKey ='America/New_York';
            u2.LocaleSidKey = 'en_US';
            u2.EmailEncodingKey = 'UTF-8';
            u2.ProfileId = p.id;
            u2.LanguageLocaleKey = 'en_US';
            u2.Country = 'United Kingdom';
        insert u2;

        for (Integer i=0;i<200;i++) {

            Lead ld = new Lead(
                Name = 'Test Lead 2',
                OwnerId = u2.Id
            );
            leads.add(ld);
        }

        insert leads;

        Set<Id> leadIds = new Set<Id>();
        for(Lead  l1 : leads){
            leadIds.add(l1.Id);
        }
        
        for(Lead l2: [Select Id, Owner_Lookup__c, OwnerId from Lead where Id in : leadIds]){
            System.assertEquals(l2.OwnerId, l2.Owner_Lookup__c);
        }
    }
}