create or alter procedure testInsertSP 
    @testParam varchar(50),
    @scope_identity_id int OUTPUT
AS
begin
    set nocount on;

    if (isnull(@testParam, '') = 'Go')
    begin
        insert into dbo.[user] (first_name, middle_name, last_name)
        values ('Michel', 'W', 'Scott');
    end

    set @scope_identity_id = scope_identity();
end


-- declare @scope_identity_id_out int;

-- execute testInsertSP @testParam = 'Go', @scope_identity_id = @scope_identity_id_out OUTPUT;

-- print isnull(@scope_identity_id_out, -1);

-- select * from dbo.[user];

-- insert into dbo.[user] (first_name, middle_name, last_name)
-- values ('Kiran', 'K', 'Laskar');

--delete from dbo.[user];