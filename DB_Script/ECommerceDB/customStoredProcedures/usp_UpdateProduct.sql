DROP PROCEDURE IF EXISTS [dbo].[usp_UpdateProduct];
GO


CREATE PROCEDURE usp_UpdateProduct
(
    @ProductId VARCHAR(20),
    @ProductName NVARCHAR(255),
    @Description NVARCHAR(MAX) = NULL,
    @ShortDescription NVARCHAR(500) = NULL,
    @SKU VARCHAR(50),
    @Price DECIMAL(18, 2),
    @ComparePrice DECIMAL(18, 2) = NULL,
    @CostPrice DECIMAL(18, 2) = NULL,
    @CategoryId INT,
    @Brand NVARCHAR(100) = NULL,
    @Weight DECIMAL(10, 3) = NULL,
    @Dimensions NVARCHAR(50) = NULL,
    @Color NVARCHAR(50) = NULL,
    @Size NVARCHAR(50) = NULL,
    @ImageUrl NVARCHAR(255) = NULL,
    @ItemsAvailable INT = NULL, -- Optional update for quantity if needed, though usually handled separately. We'll stick to reorder settings. 
    @ReorderLevel INT = NULL,
    @ReorderQuantity INT = NULL
    -- Note: IsActive is usually handled by Delete/Restore or specific toggle. If needed here, we can add it, but Update usually implies content. Let's assume IsActive remains touched only unless Soft Delete.
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validate inputs
        IF (@ProductId IS NULL OR LEN(@ProductId) < 1)
        BEGIN
            SELECT -1 AS VALUE;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductId = @ProductId)
        BEGIN
            SELECT -7 AS VALUE; -- Product does not exist
            RETURN;
        END
        
        IF (@ProductName IS NULL OR LEN(@ProductName) < 2)
        BEGIN
            SELECT -2 AS VALUE;
            RETURN;
        END
        
        IF (@SKU IS NULL OR LEN(@SKU) < 1)
        BEGIN
            SELECT -3 AS VALUE;
            RETURN;
        END

        -- Check if SKU exists for ANOTHER product
        IF EXISTS (SELECT 1 FROM Products WHERE SKU = @SKU AND ProductId != @ProductId)
        BEGIN
            SELECT -8 AS VALUE; -- SKU conflict
            RETURN;
        END
        
        IF (@Price IS NULL OR @Price <= 0)
        BEGIN
            SELECT -4 AS VALUE;
            RETURN;
        END
        
        IF (@CategoryId IS NULL)
        BEGIN
            SELECT -5 AS VALUE;
            RETURN;
        END
        
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryId = @CategoryId AND IsActive = 1)
        BEGIN
            SELECT -6 AS VALUE;
            RETURN;
        END
        
        -- Update Product
        UPDATE Products
        SET 
            ProductName = @ProductName,
            Description = @Description,
            ShortDescription = @ShortDescription,
            SKU = @SKU,
            Price = @Price,
            ComparePrice = @ComparePrice,
            CostPrice = @CostPrice,
            CategoryId = @CategoryId,
            Brand = @Brand,
            Weight = @Weight,
            Dimensions = @Dimensions,
            Color = @Color,
            Size = @Size,
            ImageUrl = @ImageUrl,
            UpdatedAt = GETUTCDATE()
        WHERE ProductId = @ProductId;

        -- Update Inventory Settings if provided
        IF (@ReorderLevel IS NOT NULL OR @ReorderQuantity IS NOT NULL)
        BEGIN
            UPDATE Inventory
            SET 
                ReorderLevel = ISNULL(@ReorderLevel, ReorderLevel),
                ReorderQuantity = ISNULL(@ReorderQuantity, ReorderQuantity),
                LastStockUpdate = GETDATE()
            WHERE ProductId = @ProductId;
        END
        
        SELECT 1 AS VALUE;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        INSERT INTO ErrorLog (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState, ErrorProcedure)
        VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_UpdateProduct');
        
        SELECT -99 AS VALUE;
    END CATCH
END;
GO
