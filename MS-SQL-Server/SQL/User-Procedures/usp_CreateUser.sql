CREATE OR ALTER PROCEDURE [dbo].usp_CreateUser
    @FirstName varchar(60),
    @MiddleName varchar(60),
    @LastName varchar(60),
    @scope_identity_id int OUTPUT
AS
    set nocount on;
    begin try
        if (isnull(@FirstName, '') <> '' or isnull(@LastName, '') <> '' or isnull(@MiddleName, '') <> '')
        begin
            insert into dbo.[user] (first_name, middle_name, last_name)
            values (@FirstName, @MiddleName, @LastName)
        end
        set @scope_identity_id = scope_identity();
    end try
    begin catch
        set @scope_identity_id = -1;
        insert into dbo.Procedure_Errors (Error_State, Error_Procedure, Error_Line, Error_Message)
        values (ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
    end catch
GO