CREATE VIEW [procfwk].[CurrentJobProperties]
AS

SELECT
	[JobId],
	[PropertyName],
	[PropertyValue]
FROM
	[procfwk].[JobProperties]
WHERE
	[ValidTo] IS NULL;