@IsTest
private class PropertyInspectionDashboardTest {
    
    private static Account createAccount() {
        Account acc = new Account(Name = 'Test Property');
        insert acc;
        return acc;
    }

    private static void createInspections(Id accountId) {
        List<Property_Inspection__c> inspections = new List<Property_Inspection__c>{
            new Property_Inspection__c(
                Related_Property__c = accountId,
                Inspection_Date__c = Date.today().addDays(-5),
                Inspection_Type__c = 'Initial',
                Inspection_Status__c = 'Completed',
                Overall_Rating__c = 4,
                Inspector_Name__c = 'Inspector A'
            ),
            new Property_Inspection__c(
                Related_Property__c = accountId,
                Inspection_Date__c = Date.today().addDays(-2),
                Inspection_Type__c = 'Annual',
                Inspection_Status__c = 'In Progress',
                Overall_Rating__c = 5,
                Inspector_Name__c = 'Inspector B'
            )
        };
        insert inspections;
    }

    @IsTest
    static void testGetInspections_NoFilter() {
        Account acc = createAccount();
        createInspections(acc.Id);

        Test.startTest();
        List<Property_Inspection__c> result =
            PropertyInspectionDashboardController.getInspections(
                acc.Id, null, null
            );
        Test.stopTest();

        System.assertEquals(2, result.size());
    }

    @IsTest
    static void testGetInspections_WithStatusFilter() {
        Account acc = createAccount();
        createInspections(acc.Id);

        List<Property_Inspection__c> result =
            PropertyInspectionDashboardController.getInspections(
                acc.Id, 'Completed', null
            );

        System.assertEquals(1, result.size());
        System.assertEquals('Completed', result[0].Inspection_Status__c);
    }

    @IsTest
    static void testGetInspections_WithTypeFilter() {
        Account acc = createAccount();
        createInspections(acc.Id);

        List<Property_Inspection__c> result =
            PropertyInspectionDashboardController.getInspections(
                acc.Id, null, 'Initial'
            );

        System.assertEquals(1, result.size());
        System.assertEquals('Initial', result[0].Inspection_Type__c);
    }

    @IsTest
    static void testGetInspections_NullAccount() {
        List<Property_Inspection__c> result =
            PropertyInspectionDashboardController.getInspections(
                null, null, null
            );

        System.assertEquals(0, result.size());
    }    

    @IsTest
    static void testGetAverageRating() {
        Account acc = createAccount();
        createInspections(acc.Id);

        Decimal avgRating =
            PropertyInspectionDashboardController.getAverageRating(acc.Id);

        System.assertEquals(4.5, avgRating);
    }

    @IsTest
    static void testGetAverageRating_NullAccount() {
        Decimal avgRating =
            PropertyInspectionDashboardController.getAverageRating(null);

        System.assertEquals(null, avgRating);
    }
}
