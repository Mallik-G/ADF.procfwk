CREATE TABLE [procfwk].[Jobs] (
    [JobId]          INT            IDENTITY (1, 1) NOT NULL,
    [JobName]        VARCHAR (225)  NOT NULL,
    [JobDescription] VARCHAR (4000) NULL,
    [Enabled]          BIT CONSTRAINT [DF_Jobs_Enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED ([JobId] ASC)
);