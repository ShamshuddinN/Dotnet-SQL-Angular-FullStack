CREATE PROCEDURE usp_InsertProduct
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
    @InitialQuantity INT = 0,
    @ReorderLevel INT = 10,
    @ReorderQuantity INT = 50
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
        
        IF EXISTS (SELECT 1 FROM Products WHERE ProductId = @ProductId)
        BEGIN
            SELECT -7 AS VALUE;
            RETURN;
        END
        
        IF EXISTS (SELECT 1 FROM Products WHERE SKU = @SKU)
        BEGIN
            SELECT -8 AS VALUE;
            RETURN;
        END
        
        IF (@InitialQuantity < 0)
        BEGIN
            SELECT -9 AS VALUE;
            RETURN;
        END
        
        -- Insert product
        INSERT INTO Products (
            ProductId, ProductName, Description, ShortDescription, SKU, Price, 
            ComparePrice, CostPrice, CategoryId, Brand, Weight, Dimensions, 
            Color, Size, ImageUrl
        )
        VALUES (
            @ProductId, @ProductName, @Description, @ShortDescription, @SKU, @Price,
            @ComparePrice, @CostPrice, @CategoryId, @Brand, @Weight, @Dimensions,
            @Color, @Size, @ImageUrl
        );
        
        -- Insert inventory record
        INSERT INTO Inventory (ProductId, QuantityAvailable, ReorderLevel, ReorderQuantity)
        VALUES (@ProductId, @InitialQuantity, @ReorderLevel, @ReorderQuantity);
        
        SELECT 1 AS VALUE;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- Log error details
        INSERT INTO ErrorLog (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState, ProcedureName)
        VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_InsertProduct');
        
        SELECT -99 AS VALUE;
    END CATCH
END;
GO