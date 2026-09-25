select * from Procedure_Errors;

declare @Success bit;
exec usp_CreateUser
    @FirstName = 'Gohn',
    @MiddleName = 'B.',
    @LastName = 'Dof',
    @Success = @Success OUTPUT

print 'Success: ' + cast(@Success as varchar(10));

select * from [user];

SELECT referencing_schema_name, referencing_entity_name, referencing_id, referencing_class_desc, is_caller_dependent  
FROM sys.dm_sql_referencing_entities ('usp_CreateUser', 'OBJECT');   
GO

SELECT OBJECT_DEFINITION (OBJECT_ID(N'OpenStore.dbo.usp_CreateUser'));

select * from sys.dm_sql_referencing_entities('OpenStore.dbo.[user]', 'OBJECT');