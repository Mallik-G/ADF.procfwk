CREATE TABLE [procfwk].[Stages] (
    [StageId]          INT            IDENTITY (1, 1) NOT NULL,
    [StageName]        VARCHAR (225)  NOT NULL,
    [StageDescription] VARCHAR (4000) NULL,
    [JobId]            INT            NOT NULL,
    [Enabled]          BIT CONSTRAINT [DF_Stages_Enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Stages] PRIMARY KEY CLUSTERED ([StageId] ASC),
    CONSTRAINT [FK_Stages_Jobs] FOREIGN KEY ([JobId]) REFERENCES [procfwk].[Jobs] ([JobId])
);

-- Each job is comprised of one or more stages, each stage can contain one or more stages. Each stage in turn contain one or more pipelines that can be run as a set.