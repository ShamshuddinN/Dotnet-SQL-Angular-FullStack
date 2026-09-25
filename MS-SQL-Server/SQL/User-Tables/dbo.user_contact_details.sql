SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF Object_ID('dbo.user_contact_details', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[user_contact_details](
        [contact_details_id] [int] IDENTITY(1,1) NOT NULL,
        [user_id] [int] NOT NULL,
        [user_email] [varchar](400) NULL,
        [contact_type1] [int] NULL,
        [contact_type1_data] [varchar](100) NULL,
        [contact_type2] [int] NULL,
        [contact_type2_data] [varchar](100) NULL,
        [address_type1] [int] NULL,
        [address_type1_data] [varchar](max) NULL,
        [address_type2] [int] NULL,
        [address_type2_data] [varchar](max) NULL,
        [additional_info] [varchar](500) NULL,
        [comments] [varchar](max) NULL
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

    ALTER TABLE [dbo].[user_contact_details] ADD PRIMARY KEY CLUSTERED 
    (
        [contact_details_id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

    ALTER TABLE [dbo].[user_contact_details]  WITH CHECK ADD  CONSTRAINT [fk_user_contact_details_user] FOREIGN KEY([user_id])
    REFERENCES [dbo].[user] ([id])
    ON DELETE CASCADE

    ALTER TABLE [dbo].[user_contact_details] CHECK CONSTRAINT [fk_user_contact_details_user]

    ALTER TABLE [dbo].[user_contact_details]  WITH CHECK ADD  CONSTRAINT [fk_user_contact_details_user_address_types1] FOREIGN KEY([address_type1])
    REFERENCES [dbo].[user_address_types] ([address_type_id])

    ALTER TABLE [dbo].[user_contact_details] CHECK CONSTRAINT [fk_user_contact_details_user_address_types1]

    ALTER TABLE [dbo].[user_contact_details]  WITH CHECK ADD  CONSTRAINT [fk_user_contact_details_user_address_types2] FOREIGN KEY([address_type2])
    REFERENCES [dbo].[user_address_types] ([address_type_id])

    ALTER TABLE [dbo].[user_contact_details] CHECK CONSTRAINT [fk_user_contact_details_user_address_types2]

    ALTER TABLE [dbo].[user_contact_details]  WITH CHECK ADD  CONSTRAINT [fk_user_contact_details_user_contact_types1] FOREIGN KEY([contact_type1])
    REFERENCES [dbo].[user_contact_types] ([contact_type_id])

    ALTER TABLE [dbo].[user_contact_details] CHECK CONSTRAINT [fk_user_contact_details_user_contact_types1]

    ALTER TABLE [dbo].[user_contact_details]  WITH CHECK ADD  CONSTRAINT [fk_user_contact_details_user_contact_types2] FOREIGN KEY([contact_type2])
    REFERENCES [dbo].[user_contact_types] ([contact_type_id])

    ALTER TABLE [dbo].[user_contact_details] CHECK CONSTRAINT [fk_user_contact_details_user_contact_types2]
END
GO