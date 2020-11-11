CREATE PROCEDURE [procfwkHelpers].[SetDefaultProperties]
AS
BEGIN
	EXEC [procfwkHelpers].[AddProperty]
		@PropertyName = N'PipelineStatusCheckDuration',
		@PropertyValue = N'30',
		@Description = N'Duration applied to the Wait activity within the Infant pipeline Until iterations.';

	EXEC [procfwkHelpers].[AddProperty]
		@PropertyName = N'UnknownWorkerResultBlocks',
		@PropertyValue = N'1',
		@Description = N'If a worker pipeline returns an unknown status. Should this block and fail downstream pipeline? 1 = Yes, 0 = No.';

	EXEC [procfwkHelpers].[AddProperty]
		@PropertyName = N'CancelledWorkerResultBlocks',
		@PropertyValue = N'1',
		@Description = N'If a worker pipeline returns an cancelled status. Should this block and fail downstream pipeline? 1 = Yes, 0 = No.';

	EXEC [procfwkHelpers].[AddProperty]
		@PropertyName = N'UseFrameworkEmailAlerting',
		@PropertyValue = N'1',
		@Description = N'Do you want the framework to handle pipeline email alerts via the database metadata? 1 = Yes, 0 = No.';

	EXEC [procfwkHelpers].[AddProperty]
		@PropertyName = N'EmailAlertBodyTemplate',
		@PropertyValue = 
		N'<hr/><strong>Pipeline Name: </strong>##PipelineName###<br/>
	<strong>Status: </strong>##Status###<br/><br/>
	<strong>Execution ID: </strong>##ExecId###<br/>
	<strong>Run ID: </strong>##RunId###<br/><br/>
	<strong>Start Date Time: </strong>##StartDateTime###<br/>
	<strong>End Date Time: </strong>##EndDateTime###<br/>
	<strong>Duration (Minutes): </strong>##Duration###<br/><br/>
	<strong>Called by Data Factory: </strong>##CalledByADF###<br/>
	<strong>Executed by Data Factory: </strong>##ExecutedByADF###<br/><hr/>',
		@Description = N'Basic HTML template of execution information used as the eventual body in email alerts sent.';

	EXEC [procfwkHelpers].[AddProperty]
		@PropertyName = N'SPNHandlingMethod',
		@PropertyValue = N'StoreInDatabase',
		@Description = N'Accepted values: StoreInDatabase, StoreInKeyVault. See v1.8.2 release notes for full details.';
END;