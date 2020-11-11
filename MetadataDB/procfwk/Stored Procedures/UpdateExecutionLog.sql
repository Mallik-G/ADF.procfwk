CREATE PROCEDURE [procfwk].[UpdateExecutionLog]
	(
		@JobId INT,
		@PerformErrorCheck BIT = 1
	)
AS
BEGIN
	SET NOCOUNT ON;
		
	DECLARE @AllCount INT
	DECLARE @SuccessCount INT

	IF @PerformErrorCheck = 1
	BEGIN
		--Check current execution
		SELECT @AllCount = COUNT(0) FROM [procfwk].[CurrentExecution] WHERE [JobId] = @JobId
		SELECT @SuccessCount = COUNT(0) FROM [procfwk].[CurrentExecution] WHERE [JobId] = @JobId AND [PipelineStatus] = 'Success'

		IF @AllCount <> @SuccessCount
			BEGIN
				RAISERROR('Framework execution complete but not all Worker pipelines succeeded. See the [procfwk].[CurrentExecution] table for details',16,1);
				RETURN 0;
			END;
	END;

	--Do this if no error raised and when called by the execution wrapper (OverideRestart = 1).
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
		[EndDateTime],
		[AdfPipelineRunId],
		[PipelineParamsUsed]
		)
	SELECT
		[LocalExecutionId],
		[JobId]
		[StageId],
		[PipelineId],
		[CallingDataFactoryName],
		[ResourceGroupName],
		[DataFactoryName],
		[PipelineName],
		[StartDateTime],
		[PipelineStatus],
		[EndDateTime],
		[AdfPipelineRunId],
		[PipelineParamsUsed]
	FROM
		[procfwk].[CurrentExecution]
	WHERE [JobId] = @JobId;

	DELETE FROM [procfwk].[CurrentExecution] 
	WHERE [JobId] = @JobId;

END;