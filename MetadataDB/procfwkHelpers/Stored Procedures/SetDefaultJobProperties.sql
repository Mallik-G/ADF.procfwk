CREATE PROCEDURE [procfwkHelpers].[SetDefaultJobProperties]
AS
BEGIN
	EXEC [procfwkHelpers].[AddJobProperty]
		@JobId = 1,
		@PropertyName = N'OverideRestart',
		@PropertyValue = N'0',
		@Description = N'Should processing not be restarted from the point of failure or should a new execution will be created regardless. 1 = Start New, 0 = Restart. ';

	EXEC [procfwkHelpers].[AddJobProperty]
		@JobId = 1,
		@PropertyName = N'FailureHandling',
		@PropertyValue = N'Simple',
		@Description = N'Accepted values: None, Simple, DependencyChain. Controls processing bahaviour in the event of Worker failures. See v1.8 release notes for full details.';

	EXEC [procfwkHelpers].[AddJobProperty]
		@JobId = 1,
		@PropertyName = N'ExecutionPrecursorProc',
		@PropertyValue = N'[dbo].[ExampleCustomExecutionPrecursor]',
		@Description = N'This procedure will be called first in the parent pipeline and can be used to perform/update any required custom behaviour in the framework execution. For example, enable/disable Worker pipelines given a certain run time/day. Invalid proc name values will be ignored.'

	EXEC [procfwkHelpers].[AddJobProperty]
		@JobId = 2,
		@PropertyName = N'OverideRestart',
		@PropertyValue = N'0',
		@Description = N'Should processing not be restarted from the point of failure or should a new execution will be created regardless. 1 = Start New, 0 = Restart. ';

	EXEC [procfwkHelpers].[AddJobProperty]
		@JobId = 2,
		@PropertyName = N'FailureHandling',
		@PropertyValue = N'Simple',
		@Description = N'Accepted values: None, Simple, DependencyChain. Controls processing bahaviour in the event of Worker failures. See v1.8 release notes for full details.';

	EXEC [procfwkHelpers].[AddJobProperty]
		@JobId = 3,
		@PropertyName = N'OverideRestart',
		@PropertyValue = N'0',
		@Description = N'Should processing not be restarted from the point of failure or should a new execution will be created regardless. 1 = Start New, 0 = Restart. ';

	EXEC [procfwkHelpers].[AddJobProperty]
		@JobId = 3,
		@PropertyName = N'FailureHandling',
		@PropertyValue = N'Simple',
		@Description = N'Accepted values: None, Simple, DependencyChain. Controls processing bahaviour in the event of Worker failures. See v1.8 release notes for full details.';

END;