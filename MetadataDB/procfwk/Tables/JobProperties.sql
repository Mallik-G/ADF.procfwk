-- This table is to hold job level properties like restartability of a job etc. The other properties table can hold frameowrk level props. 
-- Let's say we want to stop put all jobs on hold for some maintenance activity or some system is down, instead of updating hundreds of jobs on the platform from enabled to disable, we can just update here
-- However, we need to make a check on that property at the start of each processing  
CREATE TABLE [procfwk].[JobProperties]
	(
	[JobId] INT NOT NULL,
	[PropertyId] [int] IDENTITY (1, 1) NOT NULL,
	[PropertyName] [varchar](128) NOT NULL,
	[PropertyValue] [nvarchar](MAX) NOT NULL,
	[Description] [nvarchar](MAX) NULL,
	[ValidFrom] [datetime] CONSTRAINT [DF_JobProperties_ValidFrom] DEFAULT (GETDATE()) NOT NULL,
	[ValidTo] [datetime] NULL,
	CONSTRAINT [PK_JobProperties] PRIMARY KEY CLUSTERED ([PropertyId] ASC, [PropertyName] ASC),
	CONSTRAINT [FK_JobProperties_Jobs] FOREIGN KEY ([JobId]) REFERENCES [procfwk].[Jobs] ([JobId])
	)
GO