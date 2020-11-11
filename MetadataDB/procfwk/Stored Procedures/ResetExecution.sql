CREATE PROCEDURE [procfwk].[ResetExecution]
	(
		@JobId INT
	)
AS
BEGIN 
	SET NOCOUNT	ON;

	--capture any pipelines that might be in an unexpected state
	INSERT INTO [procfwk].[ExecutionLog]
		(
		[LocalExecutionId],
		[JobId],
		[StageId],
		[PipelineId],
		[CallingDataFactoryName],
		[ResourceGroupName],
		[DataFactoryName],
		[PipelineName],
		[StartDateTime],
		[PipelineStatus],
		[EndDateTime]
		)
	SELECT
		[LocalExecutionId],
		[JobId],
		[StageId],
		[PipelineId],
		[CallingDataFactoryName],
		[ResourceGroupName],
		[DataFactoryName],
		[PipelineName],
		[StartDateTime],
		'Unknown',
		[EndDateTime]
	FROM
		[procfwk].[CurrentExecution]
	WHERE
		[JobId] = @JobId
	AND
		--these are predicted states
		[PipelineStatus] NOT IN
			(
			'Success',
			'Failed',
			'Blocked',
			'Cancelled'
			);
		
	--reset status ready for next attempt
	UPDATE
		[procfwk].[CurrentExecution]
	SET
		[StartDateTime] = NULL,
		[EndDateTime] = NULL,
		[PipelineStatus] = NULL,
		[LastStatusCheckDateTime] = NULL,
		[AdfPipelineRunId] = NULL,
		[PipelineParamsUsed] = NULL,
		[IsBlocked] = 0
	WHERE
		[JobId] = @JobId
	AND
		(ISNULL([PipelineStatus],'') <> 'Success'
		OR [IsBlocked] = 1);
	
	--return current execution id
	SELECT DISTINCT
		[LocalExecutionId] AS ExecutionId
	FROM
		[procfwk].[CurrentExecution]
	WHERE 
		[JobId] = @JobId;
END;