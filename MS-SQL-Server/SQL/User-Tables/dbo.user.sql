SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF Object_ID('dbo.user', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[user](
        [id] [int] IDENTITY(1000,1) NOT NULL,
        [first_name] [varchar](60) NULL,
        [middle_name] [varchar](60) NULL,
        [last_name] [varchar](60) NULL,
        [is_active] [bit] NOT NULL,
        [profile_pic] [varchar](max) NULL
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    ALTER TABLE [dbo].[user] ADD PRIMARY KEY CLUSTERED 
    (
        [id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ALTER TABLE [dbo].[user] ADD  DEFAULT ((1)) FOR [is_active]
END
GO

