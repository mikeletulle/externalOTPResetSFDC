public without sharing class PasswordResetController {
    
    @AuraEnabled
    public static User getUserByToken(String token) {
        
        System.debug('about to select token record with token='+ token);
        Password_Reset_Token__c tokenRecord = [
            SELECT Id, User__c, Expiration_Date__c 
            FROM Password_Reset_Token__c 
            WHERE Token__c = :token 
            Order By Expiration_Date__c DESC LIMIT 1
        ];
        System.debug(tokenRecord);
        DateTime expTime = DateTime.now()-(3/24);
        System.debug('expTime = ' + expTime);
        if (tokenRecord != null && tokenRecord.Expiration_Date__c > expTime ) {
            System.debug('valid token found');
            return [SELECT Id, Name, Email FROM User WHERE Id = :tokenRecord.User__c LIMIT 1];
        } else {
            System.debug('no valid token found');
            throw new AuraHandledException('Invalid or expired token expDateTime= ' + tokenRecord.Expiration_Date__c + ' expTime = ' +  expTime);
           
        }
    }
    
    @AuraEnabled
    public static void resetUserPassword(String userId, String newPassword) {
        try {
            System.setPassword(userId, newPassword);
            Password_Reset_Token__c tokenRecord = [
                SELECT Id FROM Password_Reset_Token__c WHERE User__c = :userId Order By Expiration_Date__c DESC LIMIT 1
            ];
            if (tokenRecord != null) {
                delete tokenRecord;
            }
        } catch (Exception e) {
            throw new AuraHandledException('Failed to reset password: ' + e.getMessage());
        }
    }
}

