SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF Object_ID('dbo.user_address_types', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[user_address_types](
        [address_type_id] [int] IDENTITY(1,1) NOT NULL,
        [address_type_name] [varchar](60) NULL
    ) ON [PRIMARY]

    ALTER TABLE [dbo].[user_address_types] ADD PRIMARY KEY CLUSTERED 
    (
        [address_type_id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
