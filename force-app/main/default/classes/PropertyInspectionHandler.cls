public with sharing class PropertyInspectionHandler {

    // === TEST HOOK ===
    @TestVisible
    static Boolean forceExceptionForTest = false;

    /* =========================================================
       1. Calculate Average Inspection Rating
       ========================================================= */
    public static Decimal calculateAverageRating(Id accountId) {
        if (accountId == null) {
            throw new IllegalArgumentException('Account Id cannot be null');
        }

        try {
            if (forceExceptionForTest) {
                throw new QueryException('Forced exception for test');
            }

            AggregateResult ar = [
                SELECT AVG(Overall_Rating__c) avgRating
                FROM Property_Inspection__c
                WHERE Related_Property__c = :accountId
                AND Overall_Rating__c != null
            ];

            return (Decimal) ar.get('avgRating');

        } catch (Exception e) {
            System.debug('Error calculating average rating: ' + e.getMessage());
            throw e;
        }
    }

    /* =========================================================
       2. Get Overdue Inspections
       ========================================================= */
    public static List<Property_Inspection__c> getOverdueInspections() {
        try {
            if (forceExceptionForTest) {
                throw new QueryException('Forced exception for test');
            }

            return [
                SELECT Id, Inspection_Date__c, Inspection_Status__c, Related_Property__c
                FROM Property_Inspection__c
                WHERE Inspection_Date__c < :Date.today()
                AND Inspection_Status__c IN ('Scheduled', 'In Progress')
            ];

        } catch (Exception e) {
            System.debug('Error retrieving overdue inspections: ' + e.getMessage());
            throw e;
        }
    }

    /* =========================================================
       3. Update Account with Latest Inspection
       ========================================================= */
    public static void updateAccountWithLatestInspection(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        try {
            if (forceExceptionForTest) {
                throw new DmlException('Forced exception for test');
            }

            List<Property_Inspection__c> inspections = [
                SELECT Related_Property__c,
                       Inspection_Date__c,
                       Inspection_Type__c,
                       Inspection_Status__c,
                       Overall_Rating__c
                FROM Property_Inspection__c
                WHERE Related_Property__c IN :accountIds
                ORDER BY Inspection_Date__c DESC
            ];

            Map<Id, Property_Inspection__c> latestMap = new Map<Id, Property_Inspection__c>();

            for (Property_Inspection__c pi : inspections) {
                if (!latestMap.containsKey(pi.Related_Property__c)) {
                    latestMap.put(pi.Related_Property__c, pi);
                }
            }

            List<Account> accountsToUpdate = new List<Account>();

            for (Id accId : latestMap.keySet()) {
                Property_Inspection__c pi = latestMap.get(accId);

                accountsToUpdate.add(new Account(
                    Id = accId,
                    Description =
                        'Latest Inspection Summary\n' +
                        'Date: ' + pi.Inspection_Date__c + '\n' +
                        'Type: ' + pi.Inspection_Type__c + '\n' +
                        'Status: ' + pi.Inspection_Status__c + '\n' +
                        'Rating: ' + pi.Overall_Rating__c
                ));
            }

            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }

        } catch (Exception e) {
            System.debug('Error updating Account description: ' + e.getMessage());
            throw e;
        }
    }
}
