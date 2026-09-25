SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF Object_ID('dbo.user_account', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[user_account](
        [account_id] [int] IDENTITY(100,1) NOT NULL,
        [user_id] [int] NOT NULL,
        [username] [varchar](50) NOT NULL,
        [is_active] [bit] NOT NULL,
        [password_hash] [varchar](max) NOT NULL
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

    ALTER TABLE [dbo].[user_account] ADD PRIMARY KEY CLUSTERED 
    (
        [account_id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

    ALTER TABLE [dbo].[user_account] ADD  DEFAULT ((0)) FOR [is_active]

    ALTER TABLE [dbo].[user_account]  WITH CHECK ADD  CONSTRAINT [fk_user_account_user] FOREIGN KEY([user_id])
    REFERENCES [dbo].[user] ([id])
    ON DELETE CASCADE

    ALTER TABLE [dbo].[user_account] CHECK CONSTRAINT [fk_user_account_user]

END
