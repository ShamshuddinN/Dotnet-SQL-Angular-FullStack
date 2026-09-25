create or alter procedure dbo.usp_RegisterUser
    -- For User Contact Creation
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
    
    -- For User Account Creation
    @userName varchar(50),
    @passwordHash varchar(max),

    --For User Creation
    @firstName varchar(60),
    @middleName varchar(60),
    @lastName varchar(60),
    @isActive bit = 1,
    @profilePicPath varchar(max) = null,

    --For Output
    @success bit OUTPUT
AS
begin
   set nocount on;
   declare @out_scope_identity int = 0;
   set @success = 0;
   declare @user_id int = 0;

   begin try
    begin transaction;

        --User Creation
        if ( isnull(@firstName, '') <> '' or isnull(@lastName, '') <> '' or isnull(@middleName, '') <> '' )
        begin
            execute dbo.usp_CreateUser @FirstName = @firstName, @MiddleName = @middleName, @LastName = @lastName, @scope_identity_id = @out_scope_identity OUTPUT;

            if isnull(@out_scope_identity, 0) = 0
            begin
                rollback transaction;
                throw 50000, 'User Creation Failed - Logical Error', 1;
            end
            else if isnull(@out_scope_identity, 0) < 0
            begin
                rollback transaction;
                throw 50000, 'User Creation Failed - Technical Error', 1;
            end
            else if @out_scope_identity is null
            begin
                rollback transaction;
                throw 50000, 'User Creation Failed - Scope Identity is NULL', 1;
            end
        end

        set @user_id = @out_scope_identity;

        --User Account Creation
        if ( isnull(@userName, '') <> '' and isnull(@passwordHash, '') <> '' and isnull(@user_id, 0) > 0 )
        begin
            execute dbo.usp_CreateUserAccount @userID = @user_id, @userName = @userName, @passwordHash = @passwordHash, @scope_identity_id = @out_scope_identity OUTPUT;

            if isnull(@out_scope_identity, 0) = 0
            begin
                rollback transaction;
                throw 50000, 'User Account Creation Failed - Logical Error', 1;
            end
            else if isnull(@out_scope_identity, 0) < 0
            begin
                rollback transaction;
                throw 50000, 'User Account Creation Failed - Technical Error', 1;
            end
            else if @out_scope_identity is null
            begin
                rollback transaction;
                throw 50000, 'User Account Creation Failed - Scope Identity is NULL', 1;
            end
        end

        --User Contact Creation
        if ((isnull(@out_scope_identity, 0) > 0) AND (isnull(@user_email, '') <> '') and (isnull(@contact_type1, 0) > 0) and (isnull(@user_id, 0) > 0))
        begin
            execute usp_CreateUserContactDetails @user_id = @user_id, @user_email = @user_email, @contact_type1 = @contact_type1, @contact_type1_data = @contact_type1_data, @contact_type2 = @contact_type2, @contact_type2_data = @contact_type2_data, @address_type1 = @address_type1, @address_type1_data = @address_type1_data, @address_type2 = @address_type2, @address_type2_data = @address_type2_data, @additional_info = @additional_info, @comments = @comments, @scope_identity_id = @out_scope_identity OUTPUT;

            if isnull(@out_scope_identity, 0) = 0
            begin
                rollback transaction;
                throw 50000, 'User Contact Creation Failed - Logical Error', 1; 
            end
            else if isnull(@out_scope_identity, 0) < 0
            begin
                rollback transaction;
                throw 50000, 'User Contact Creation Failed - Technical Error', 1;
            end
            else if @out_scope_identity is null
            begin
                rollback transaction;
                throw 50000, 'User Contact Creation Failed - Scope Identity is NULL', 1;
            end
        end
        else
        begin
            rollback transaction;
            throw 50000, 'User Contact Creation Failed - Logical Error', 1;
        end
    
    set @success = 1;

    commit transaction;
    end try
    begin catch
        insert into dbo.Procedure_Errors (Error_State, Error_Procedure, Error_Line, Error_Message)
        values (ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

        if @@trancount > 0
            rollback transaction;
    end catch
end
