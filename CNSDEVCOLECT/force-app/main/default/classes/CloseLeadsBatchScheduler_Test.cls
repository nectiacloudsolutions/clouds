@isTest
class CloseLeadsBatchScheduler_Test {
    // Dummy CRON expression: midnight on March 15, 2030.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2023';

    @isTest
    static void test_scheduler(){
        Test.startTest();
        String jobId = System.schedule('CloseLeadsBatchScheduler_Test', CRON_EXP, new CloseLeadsBatchScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2023-03-15 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}