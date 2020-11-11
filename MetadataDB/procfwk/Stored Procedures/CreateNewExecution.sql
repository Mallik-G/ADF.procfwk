CREATE PROCEDURE [procfwk].[CreateNewExecution]
	(
	@CallingDataFactoryName NVARCHAR(200),
	@JobId INT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @LocalExecutionId UNIQUEIDENTIFIER = NEWID()

	--TRUNCATE TABLE [procfwk].[CurrentExecution];

	INSERT INTO [procfwk].[CurrentExecution]
		(
		[LocalExecutionId],
		[JobId],
		[StageId],
		[PipelineId],
		[CallingDataFactoryName],
		[ResourceGroupName],
		[DataFactoryName],
		[PipelineName]
		)
	SELECT
		@LocalExecutionId,
		@JobId,
		p.[StageId],
		p.[PipelineId],
		@CallingDataFactoryName,
		d.[ResourceGroupName],
		d.[DataFactoryName],
		p.[PipelineName]
	FROM
		[procfwk].[Pipelines] p
		INNER JOIN [procfwk].[Stages] s
			ON p.[StageId] = s.[StageId]
		INNER JOIN [procfwk].[Jobs] j
			ON j.[JobId] = s.[JobId]
		INNER JOIN [procfwk].[DataFactorys] d
			ON p.[DataFactoryId] = d.[DataFactoryId]
	WHERE
		p.[Enabled] = 1
		AND s.[Enabled] = 1
		AND j.[Enabled] = 1

	-- ALTER INDEX [IDX_GetPipelinesInStage] ON [procfwk].[CurrentExecution]
	-- REBUILD;

	SELECT
		@LocalExecutionId AS ExecutionId
END;