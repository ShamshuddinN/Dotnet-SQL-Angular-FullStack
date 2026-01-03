DROP PROCEDURE IF EXISTS usp_UpdateInventory;
GO
-- =============================================
-- Update Inventory Procedure
-- =============================================
CREATE PROCEDURE usp_UpdateInventory
(
    @ProductId VARCHAR(20),
    @QuantityAdjustment INT,
    @Operation NVARCHAR(20) -- 'Add', 'Remove', 'Set'
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validate inputs
        IF (@ProductId IS NULL)
            RETURN -1;
        
        IF (@QuantityAdjustment IS NULL)
            RETURN -2;
        
        IF (@Operation NOT IN ('Add', 'Remove', 'Set'))
            RETURN -3;
        
        -- Check if product exists
        IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductId = @ProductId)
            RETURN -4;
        
        -- Update inventory based on operation
        IF (@Operation = 'Add')
        BEGIN
            UPDATE Inventory
            SET QuantityAvailable = QuantityAvailable + @QuantityAdjustment,
                LastStockUpdate = GETDATE()
            WHERE ProductId = @ProductId;
        END
        ELSE IF (@Operation = 'Remove')
        BEGIN
            DECLARE @CurrentQuantity INT;
            SELECT @CurrentQuantity = QuantityAvailable FROM Inventory WHERE ProductId = @ProductId;
            
            IF (@CurrentQuantity < @QuantityAdjustment)
                RETURN -5; -- Insufficient quantity
            
            UPDATE Inventory
            SET QuantityAvailable = QuantityAvailable - @QuantityAdjustment,
                LastStockUpdate = GETDATE()
            WHERE ProductId = @ProductId;
        END
        ELSE IF (@Operation = 'Set')
        BEGIN
            IF (@QuantityAdjustment < 0)
                RETURN -6; -- Invalid quantity
            
            UPDATE Inventory
            SET QuantityAvailable = @QuantityAdjustment,
                LastStockUpdate = GETDATE()
            WHERE ProductId = @ProductId;
        END;
        
        -- Check for low stock alert
        DECLARE @ReorderLevel INT;
        SELECT @ReorderLevel = ReorderLevel FROM Inventory WHERE ProductId = @ProductId;
        
        IF ((SELECT QuantityAvailable FROM Inventory WHERE ProductId = @ProductId) <= @ReorderLevel)
            RETURN 2; -- Low stock alert
        
        RETURN 1; -- Success
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- Log error details
        -- INSERT INTO ErrorLog (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState, ProcedureName)
        -- VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_UpdateInventory');
        
        RETURN -99;
    END CATCH
END;
GO