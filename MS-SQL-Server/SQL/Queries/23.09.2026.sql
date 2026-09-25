declare @user_email varchar(400) = 'example@example.com';
declare @contact_type1 int = 1;
declare @contact_type1_data varchar(100) = @user_email; 
declare @contact_type2 int = 2;
declare @contact_type2_data varchar(100) = '123-456-7890';

declare @address_type1 int = 1;
declare @address_type1_data varchar(max) = '123 Main St, Anytown, USA';
declare @address_type2 int = null;
declare @address_type2_data varchar(max) = null;
declare @additional_info varchar(500) = null;
declare @comments varchar(max) = null;

    -- For User Account Creation
declare @userName varchar(50) = 'openuser434';
declare @passwordHash varchar(max) = 'hashed_password_here';

    --For User Creation
declare @firstName varchar(60) = 'John';
declare @middleName varchar(60) = 'Doe';
declare @lastName varchar(60) = 'Smith';
declare @isActive bit = 1;
declare @profilePicPath varchar(max) = null;

    --For Output
declare @success bit;

exec usp_RegisterUser
    @user_email = @user_email,
    @contact_type1 = @contact_type1,
    @contact_type1_data = @contact_type1_data,
    @contact_type2 = @contact_type2,
    @contact_type2_data = @contact_type2_data,
    @address_type1 = @address_type1,
    @address_type1_data = @address_type1_data,
    @address_type2 = @address_type2,
    @address_type2_data = @address_type2_data,
    @additional_info = @additional_info,
    @comments = @comments,
    @userName = @userName,
    @passwordHash = @passwordHash,
    @firstName = @firstName,
    @middleName = @middleName,
    @lastName = @lastName,
    @isActive = @isActive,
    @profilePicPath = @profilePicPath,
    @success = @success OUTPUT;

select @success as RegistrationSuccess;

--select * from Procedure_Errors order by 1 desc;


--declare @out_scope_identity int = 0;

--exec CreateUserAccount 'openuser343', 'hashed_password_here', @scope_identity_id = @out_scope_identity OUTPUT;

--print 'Scope Identity ID: ' + cast(@out_scope_identity as varchar(10));

--select * from dbo.[user_account] where username = 'openuser434';
