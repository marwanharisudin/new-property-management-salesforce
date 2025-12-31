public with sharing class PropertyInspectionDashboardController {

    @AuraEnabled(cacheable=true)
    public static List<Property_Inspection__c> getInspections(
        Id accountId,
        String statusFilter,
        String typeFilter
    ) {
        if (accountId == null) {
            return new List<Property_Inspection__c>();
        }

        String query =
            'SELECT Id, Inspection_Date__c, Inspection_Type__c, ' +
            'Inspection_Status__c, Overall_Rating__c, Inspector_Name__c ' +
            'FROM Property_Inspection__c ' +
            'WHERE Related_Property__c = :accountId';

        if (String.isNotBlank(statusFilter)) {
            query += ' AND Inspection_Status__c = :statusFilter';
        }
        if (String.isNotBlank(typeFilter)) {
            query += ' AND Inspection_Type__c = :typeFilter';
        }

        query += ' ORDER BY Inspection_Date__c DESC';

        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static Decimal getAverageRating(Id accountId) {
        if (accountId == null) return null;

        AggregateResult ar = [
            SELECT AVG(Overall_Rating__c) avgRating
            FROM Property_Inspection__c
            WHERE Related_Property__c = :accountId
            AND Overall_Rating__c != null
        ];

        return (Decimal) ar.get('avgRating');
    }
}
