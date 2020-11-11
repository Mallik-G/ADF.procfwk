CREATE PROCEDURE [procfwkHelpers].[SetDefaultJobs]
AS
BEGIN
	DECLARE @Jobs TABLE
		(
		[JobName] [VARCHAR](225) NOT NULL,
		[JobDescription] [VARCHAR](4000) NULL,
		[Enabled] [BIT] NOT NULL
		)
	
	INSERT @Jobs
		(
		[JobName], 
		[JobDescription], 
		[Enabled]
		) 
	VALUES 
		('IngestSalesData', N'Ingest all datafeeds related to Sales source system.', 1),
		('ServeMarketingData', N'Transform data on data related to Marketing source system.', 1)
		
	MERGE INTO [procfwk].[Jobs] AS tgt
	USING 
		@Jobs AS src
			ON tgt.[JobName] = src.[JobName]
	WHEN MATCHED THEN
		UPDATE
		SET
			tgt.[JobDescription] = src.[JobDescription],
			tgt.[Enabled] = src.[Enabled]
	WHEN NOT MATCHED BY TARGET THEN
		INSERT
			(
			[JobName],
			[JobDescription],
			[Enabled]
			)
		VALUES
			(
			src.[JobName],
			src.[JobDescription],
			src.[Enabled]
			)
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE;	
END;