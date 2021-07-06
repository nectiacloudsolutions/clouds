@isTest
private with sharing class ReportE05E04SchedulerTest {
    
    public static String CRON_EXP = '0 0 0 1 * ? *';
    @isTest
    static void ReportE05E04SchedulerTest() {
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new ReportE05E04Scheduler());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                        FROM CronTrigger 
                        WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        Test.stopTest();
    }
}