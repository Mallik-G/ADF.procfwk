CREATE PROCEDURE [procfwk].[ExecutionWrapper]
	(
	@CallingDataFactory NVARCHAR(200),
	@JobId INT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RestartStatus BIT

	IF @CallingDataFactory IS NULL
		SET @CallingDataFactory = 'Unknown';

	--get restart overide property	
	SELECT @RestartStatus = [procfwk].[GetJobPropertyValueInternal](@JobId, 'OverideRestart')

	--check for running execution
	IF EXISTS
		(
		SELECT * FROM [procfwk].[CurrentExecution] WHERE [JobId] = @JobId AND ISNULL([PipelineStatus],'') = 'Running'
		)
		BEGIN
			RAISERROR('There is already an execution run in progress for this job. Stop this via Data Factory before restarting.',16,1);
			RETURN 0;
		END;	

	--reset and restart execution
	IF EXISTS
		(
		SELECT * FROM [procfwk].[CurrentExecution] WHERE [JobId] = @JobId AND ISNULL([PipelineStatus],'') <> 'Success'
		) 
		AND @RestartStatus = 0
		BEGIN
			EXEC [procfwk].[ResetExecution]
		END
	--capture failed execution and run new anyway
	ELSE IF EXISTS
		(
		SELECT * FROM [procfwk].[CurrentExecution] WHERE [JobId] = @JobId
		)
		AND @RestartStatus = 1
		BEGIN
			EXEC [procfwk].[UpdateExecutionLog]
				@JobId = @JobId,
				@PerformErrorCheck = 0; --Special case when OverideRestart = 1;

			EXEC [procfwk].[CreateNewExecution] 
				@CallingDataFactoryName = @CallingDataFactory,
				@JobId = @JobId
		END
	--no restart considerations, just create new execution
	ELSE
		BEGIN
			IF EXISTS --edge case, if all current workers succeeded, or some other not understood situation, archive records
				(
				SELECT * FROM [procfwk].[CurrentExecution] WHERE [JobId] = @JobId 
				)
				BEGIN
					EXEC [procfwk].[UpdateExecutionLog]
						@JobId = @JobId,
						@PerformErrorCheck = 0;
				END

			EXEC [procfwk].[CreateNewExecution] 
				@CallingDataFactoryName = @CallingDataFactory,
				@JobId = @JobId

		END
END;