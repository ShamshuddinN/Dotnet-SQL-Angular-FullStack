DROP PROCEDURE IF EXISTS [dbo].[usp_DeleteProduct];
GO


CREATE PROCEDURE usp_DeleteProduct
(
    @ProductId VARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@ProductId IS NULL OR LEN(@ProductId) < 1)
        BEGIN
            SELECT -1 AS VALUE;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductId = @ProductId)
        BEGIN
            SELECT -7 AS VALUE; -- Product not found
            RETURN;
        END

        -- Soft Delete
        UPDATE Products
        SET IsActive = 0,
            UpdatedAt = GETDATE()
        WHERE ProductId = @ProductId;

        SELECT 1 AS VALUE;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        INSERT INTO ErrorLog (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState, ErrorProcedure)
        VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_DeleteProduct');
        
        SELECT -99 AS VALUE;
    END CATCH
END;
GO
