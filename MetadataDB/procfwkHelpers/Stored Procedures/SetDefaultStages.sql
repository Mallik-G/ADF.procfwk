CREATE PROCEDURE [procfwkHelpers].[SetDefaultStages]
AS
BEGIN
	DECLARE @Stages TABLE
		(
		[StageName] [VARCHAR](225) NOT NULL,
		[StageDescription] [VARCHAR](4000) NULL,
		[JobId]            INT            NOT NULL,
		[Enabled] [BIT] NOT NULL
		)
	
	INSERT @Stages
		(
		[StageName], 
		[StageDescription], 
		[JobId],
		[Enabled]
		) 
	VALUES 
		('Extract Sales Data', N'Ingest all data from source systems.', 1, 1),
		('Transform Sales Data', N'Transform ingested data and apply business logic.', 1, 1),
		('Load Sales Data', N'Load transformed data into semantic layer.', 1, 1),
		('Prepare Marketing Data', N'Curate data in Data Warehouse.', 2, 1),
		('Generate Marketing Data Extracts', N'Generate prepared extracts from DW to storage layer.', 2, 1);	

	MERGE INTO [procfwk].[Stages] AS tgt
	USING 
		@Stages AS src
			ON tgt.[JobId] = src.[JobId]
			AND tgt.[StageName] = src.[StageName]
	WHEN MATCHED THEN
		UPDATE
		SET
			tgt.[StageDescription] = src.[StageDescription],
			tgt.[Enabled] = src.[Enabled]
	WHEN NOT MATCHED BY TARGET THEN
		INSERT
			(
			[StageName],
			[StageDescription],
			[JobId],
			[Enabled]
			)
		VALUES
			(
			src.[StageName],
			src.[StageDescription],
			src.[JobId],
			src.[Enabled]
			)
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE;	
END;