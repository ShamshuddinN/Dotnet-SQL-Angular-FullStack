CREATE OR ALTER PROCEDURE [dbo].[usp_CreateUserContactDetails]
    @user_id int,
    @user_email varchar(400),
    @contact_type1 int,
    @contact_type1_data varchar(100),
    @contact_type2 int,
    @contact_type2_data varchar(100),
    @address_type1 int,
    @address_type1_data varchar(max),
    @address_type2 int,
    @address_type2_data varchar(max),
    @additional_info varchar(500),
    @comments varchar(max),
    @scope_identity_id int OUTPUT
AS
BEGIN
    begin try
   
    if ((isnull(@user_id, 0) > 0) AND (isnull(@user_email, '') <> ''))
    begin
        insert into dbo.[user_contact_details] (user_id, user_email, contact_type1, contact_type1_data, contact_type2, contact_type2_data, address_type1, address_type1_data, address_type2, address_type2_data, additional_info, comments)
        values (@user_id, @user_email, @contact_type1, @contact_type1_data, @contact_type2, @contact_type2_data, @address_type1, @address_type1_data, @address_type2, @address_type2_data, @additional_info, @comments) ;
    end
    set @scope_identity_id = scope_identity();
    
   
    end try
    begin catch
        set @scope_identity_id = -1;
        insert into dbo.Procedure_Errors (Error_State, Error_Procedure, Error_Line, Error_Message)
        values (ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
    end catch
END