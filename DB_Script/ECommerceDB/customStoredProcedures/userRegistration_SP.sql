DROP PROCEDURE IF EXISTS [dbo].[usp_RegisterUser];
GO
-- =============================================
-- User Registration Procedure
-- =============================================

CREATE PROCEDURE usp_RegisterUser
(
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(255),
    @FullName NVARCHAR(255),
    @Gender CHAR(1),
    @DateOfBirth DATE,
    @RoleId INT,
    @PhoneNumber NVARCHAR(20) = NULL,
    @AddressLine1 NVARCHAR(255) = NULL,
    @AddressLine2 NVARCHAR(255) = NULL,
    @City NVARCHAR(100) = NULL,
    @State NVARCHAR(100) = NULL,
    @PostalCode NVARCHAR(20) = NULL,
    @Country NVARCHAR(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        -- Validate inputs
        IF (@Email IS NULL OR LEN(@Email) < 4 OR LEN(@Email) > 100)
        BEGIN
            SELECT -1 AS VALUE;
            RETURN;
        END

        IF (@PasswordHash IS NULL)
        BEGIN
            SELECT -2 AS VALUE;
            RETURN;
        END

        IF (@Gender NOT IN ('F', 'M', 'O') OR @Gender IS NULL)
        BEGIN
            SELECT -3 AS VALUE;
            RETURN;
        END
        
        IF (@DateOfBirth IS NULL OR @DateOfBirth >= CAST(GETDATE() AS DATE))
        BEGIN
            SELECT -4 AS VALUE;
            RETURN;
        END
        
        IF (DATEDIFF(d, @DateOfBirth, GETDATE()) < 6570) -- Must be at least 18 years old
        BEGIN
            SELECT -5 AS VALUE;
            RETURN;
        END
        
        IF (@FullName IS NULL OR LEN(@FullName) < 2)
        BEGIN
            SELECT -6 AS VALUE;
            RETURN;
        END
        
        IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
        BEGIN
            SELECT -7 AS VALUE;
            RETURN;
        END
        
        IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleId = @RoleId)
        BEGIN
            SELECT -8 AS VALUE;
            RETURN;
        END
        
        BEGIN TRANSACTION;

        -- Insert user
        INSERT INTO Users (Email, PasswordHash, FullName, Gender, DateOfBirth, RoleId, PhoneNumber)
        VALUES (@Email, @PasswordHash, @FullName, @Gender, @DateOfBirth, @RoleId, @PhoneNumber);
        
        DECLARE @UserId INT = SCOPE_IDENTITY();
        
        -- Insert address if provided
        IF (@AddressLine1 IS NOT NULL AND @City IS NOT NULL AND @State IS NOT NULL AND @PostalCode IS NOT NULL AND @Country IS NOT NULL)
        BEGIN
            INSERT INTO Addresses (UserId, AddressLine1, AddressLine2, City, State, PostalCode, Country, AddressType, IsDefault)
            VALUES (@UserId, @AddressLine1, @AddressLine2, @City, @State, @PostalCode, @Country, 'Both', 1);
        END;
        
        COMMIT TRANSACTION;

        SELECT @UserId AS VALUE;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- Log error details (you could implement a logging table)
        INSERT INTO ErrorLog (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState, ErrorProcedure)
        VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_RegisterUser');

        SELECT -99 AS VALUE;
    END CATCH
END;
GO