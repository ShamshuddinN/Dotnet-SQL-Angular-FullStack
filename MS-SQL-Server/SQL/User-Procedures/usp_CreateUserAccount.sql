create or alter procedure dbo.usp_CreateUserAccount
    @userID int,
    @userName varchar(50),
    @passwordHash varchar(max),
    @scope_identity_id int OUTPUT
AS
begin
   set nocount on;
   begin try
    if ( isnull(@userName, '') <> '' and isnull(@passwordHash, '') <> '' )
        begin
            insert into dbo.[user_account] (user_id, username, password_hash)
            values (@userID, @userName, @passwordHash)
        end
    set @scope_identity_id = scope_identity();
    end try
    begin catch
        set @scope_identity_id = -1;
        insert into dbo.Procedure_Errors (Error_State, Error_Procedure, Error_Line, Error_Message)
        values (ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
    end catch
end
GO
