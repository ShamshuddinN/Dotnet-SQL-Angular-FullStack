create procedure dbo.DemoProcedure
    @inputParam1 varchar(50),
    @scope_identity_id int OUTPUT
AS
begin
   set nocount on;

   begin try
   
    begin transaction;
        if (isnull(@inputParam1, '') = 'Go')
    begin
        insert into dbo.[user] (first_name, middle_name, last_name)
        values ('Michel', 'W', 'Scott');
    end

    set @scope_identity_id = scope_identity();
   
    commit transaction;
    end try
    begin catch
        insert into dbo.Procedure_Errors (Error_State, Error_Procedure, Error_Line, Error_Message)
        values (ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

    if @@trancount > 0
        rollback transaction;
    end catch
end
GO
