CREATE PROCEDURE [procfwk].[GetJobPropertyValue]
	(
	@JobId INT,
	@PropertyName VARCHAR(128)
	)
AS
BEGIN	
	DECLARE @ErrorDetail NVARCHAR(4000) = ''

	--defensive checks
	IF NOT EXISTS
		(
		SELECT * FROM [procfwk].[JobProperties] WHERE [JobId] = @JobId AND [PropertyName] = @PropertyName
		)
		BEGIN
			SET @ErrorDetail = 'Invalid job property name provided. Job Property does not exist.'
			RAISERROR(@ErrorDetail, 16, 1);
			RETURN 0;
		END
	ELSE IF NOT EXISTS
		(
		SELECT * FROM [procfwk].[JobProperties] WHERE [JobId] = @JobId AND [PropertyName] = @PropertyName AND [ValidTo] IS NULL
		)
		BEGIN
			SET @ErrorDetail = 'Job Property name provided does not have a current valid version of the required value.'
			RAISERROR(@ErrorDetail, 16, 1);
			RETURN 0;
		END
	--get valid property value
	ELSE
		BEGIN
			SELECT
				[PropertyValue]
			FROM
				[procfwk].[CurrentJobProperties]
			WHERE
				[JobId] = @JobId 
			AND 
				[PropertyName] = @PropertyName
		END
END;