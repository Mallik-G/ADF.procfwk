CREATE FUNCTION [procfwk].[GetJobPropertyValueInternal]
	(
		@JobId INT,
		@PropertyName VARCHAR(128)
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @PropertyValue NVARCHAR(MAX)

	SELECT
		@PropertyValue = ISNULL([PropertyValue],'')
	FROM
		[procfwk].[CurrentJobProperties]
	WHERE
		[JobId] = @JobId
	AND
		[PropertyName] = @PropertyName

    RETURN @PropertyValue
END;
