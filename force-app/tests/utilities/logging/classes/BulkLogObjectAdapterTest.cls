/**
* @author Gavin Palmer (gavin.palmer@cloudshiftgroup.com)
* @version 1.0
* @description Test class for the BulkLogObjectAdapter
*
* 2018-06-27 : Gavin Palmer - Original
**/
@IsTest
private class BulkLogObjectAdapterTest {

    @IsTest
    private static void errorLevelTest() {
        Logger.LoggerAdapter loggerAdapter = BulkLogObjectAdapter.getInstance('A type');
        System.assertEquals(
            BulkLogObjectAdapter.ERROR, loggerAdapter.errorLevel(),
            'The error level should return the error string'
        );
    }

    @IsTest
    private static void warningLevelTest() {
        Logger.LoggerAdapter loggerAdapter = BulkLogObjectAdapter.getInstance('A type');
        System.assertEquals(
            BulkLogObjectAdapter.WARNING, loggerAdapter.warningLevel(),
            'The warning level should return the warning string'
        );
    }

    @IsTest
    private static void infoLevelTest() {
        Logger.LoggerAdapter loggerAdapter = BulkLogObjectAdapter.getInstance('A type');
        System.assertEquals(
            BulkLogObjectAdapter.INFO, loggerAdapter.infoLevel(),
            'The info level should return the info string'
        );
    }

    @IsTest
    private static void debugLevelTest() {
        Logger.LoggerAdapter loggerAdapter = BulkLogObjectAdapter.getInstance('A type');
        System.assertEquals(
            BulkLogObjectAdapter.DEBUG, loggerAdapter.debugLevel(),
            'The debug level should return the debug string'
        );
    }

    @IsTest
    private static void logTest() {
        final String logType = 'Test Log Type';
        final String logLevel = 'Test Log Level';
        final String message = 'Test Log Message';
        BulkLogObjectAdapter loggerAdapter = BulkLogObjectAdapter.getInstance(logType);

        System.assert(
            loggerAdapter.logsToWrite.isEmpty(),
            'The logs should be empty before log is called'
        );

        loggerAdapter.log(logLevel, message);

        System.assertEquals(
            1, loggerAdapter.logsToWrite.size(),
            'The logs should not be empty after log is called'
        );
        Log__c logToAssert = loggerAdapter.logsToWrite[0];
        System.assertEquals(
            logType, logToAssert.Type__c,
            'The type should match the type passed into the adapters constructor'
        );
        System.assertEquals(
            logLevel, logToAssert.Level__c,
            'The log level should match the level passed into the log call'
        );
        System.assertEquals(
            message, logToAssert.Messages__c,
            'The message should match the message passed into the log call'
        );
    }

    @IsTest
    private static void logTestWithRecordId() {
        AccountTestFactory accountFactory = new AccountTestFactory();
        Account testAccount = (Account) accountFactory.insertSObject();
        final String logType = 'Test Log Type';
        final String logLevel = 'Test Log Level';
        final String message = 'Test Log Message';
        BulkLogObjectAdapter loggerAdapter = BulkLogObjectAdapter.getInstance(logType);

        System.assert(
            loggerAdapter.logsToWrite.isEmpty(),
            'The logs should be empty before log is called'
        );

        loggerAdapter.log(logLevel, message, testAccount.Id);

        System.assertEquals(
            1, loggerAdapter.logsToWrite.size(),
            'The logs should not be empty after log is called'
        );
        Log__c logToAssert = loggerAdapter.logsToWrite[0];
        System.assertEquals(
            logType, logToAssert.Type__c,
            'The type should match the type passed into the adapters constructor'
        );
        System.assertEquals(
            logLevel, logToAssert.Level__c,
            'The log level should match the level passed into the log call'
        );
        System.assertEquals(
            message, logToAssert.Messages__c,
            'The message should match the message passed into the log call'
        );
        System.assertEquals(
            testAccount.Id, logToAssert.Record_Id__c,
            'The record id should be appended to the log record'
        );
    }

    @IsTest
    private static void writeLogsTest() {
        System.assertEquals(
            0, [SELECT COUNT() FROM Log__c],
            'There should be no logs in the system before the test'
        );
        final String logType = 'Test Log Type';
        final String logLevel = BulkLogObjectAdapter.ERROR;
        final String message = 'Test Log Message';
        BulkLogObjectAdapter loggerAdapter = BulkLogObjectAdapter.getInstance(logType);

        loggerAdapter.log(logLevel, message);

        try {
            BulkLogObjectAdapter.writeLogs();
        } catch (Exception exceptionToHandle) {
            System.assert(
                false,
                'An error should not be thrown when writing logs, error provided: ' + exceptionToHandle.getMessage()
            );
        }

        List<Log__c> writtenLogs = [SELECT Type__c, Level__c, Messages__c FROM Log__c];

        System.assertEquals(
            1, writtenLogs.size(),
            'There should be 1 log generated in the system'
        );

        Log__c logToAssert = writtenLogs[0];
        System.assertEquals(
            logType, logToAssert.Type__c,
            'The type should match the type passed into the adapters constructor'
        );
        System.assertEquals(
            logLevel, logToAssert.Level__c,
            'The log level should match the level passed into the log call'
        );
        System.assertEquals(
            message, logToAssert.Messages__c,
            'The message should match the message passed into the log call'
        );
    }
}