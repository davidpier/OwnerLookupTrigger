/*
Description : Used to keep the Owner Lookup field in sync with the OwnerId field
              Standard OwnerId field doesn't provide access to User metadata fields
*/ 

trigger LeadOwnerLookup on Lead (before insert, before update) {
    for(Lead ld : Trigger.new){
        if(ld.OwnerId != null && ((String)ld.OwnerId).startsWith('005')) {
            ld.Owner_Lookup__c = ld.OwnerId;
        }
    }   
}