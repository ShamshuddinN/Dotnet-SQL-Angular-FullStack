DROP PROCEDURE IF EXISTS usp_AddToCart;
GO
-- =============================================
-- Add to Cart Procedure
-- =============================================
CREATE PROCEDURE usp_AddToCart
(
    @UserId INT,
    @ProductId VARCHAR(20),
    @Quantity INT = 1
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validate inputs
        IF (@UserId IS NULL)
            RETURN -1;
        
        IF (@ProductId IS NULL)
            RETURN -2;
        
        IF (@Quantity IS NULL OR @Quantity <= 0)
            RETURN -3;
        
        -- Check if user exists
        IF NOT EXISTS (SELECT 1 FROM Users WHERE UserId = @UserId AND IsActive = 1)
            RETURN -4;
        
        -- Check if product exists and is active
        IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductId = @ProductId AND IsActive = 1)
            RETURN -5;
        
        -- Check inventory availability
        DECLARE @AvailableQuantity INT;
        SELECT @AvailableQuantity = (QuantityAvailable - QuantityReserved)
        FROM Inventory
        WHERE ProductId = @ProductId;
        
        IF (@AvailableQuantity < @Quantity)
            RETURN -6;
        
        -- Get current product price
        DECLARE @CurrentPrice DECIMAL(18, 2);
        SELECT @CurrentPrice = Price
        FROM Products
        WHERE ProductId = @ProductId;
        
        -- Check if item already exists in cart
        IF EXISTS (SELECT 1 FROM Cart WHERE UserId = @UserId AND ProductId = @ProductId)
        BEGIN
            -- Update existing cart item
            DECLARE @CurrentQuantity INT;
            SELECT @CurrentQuantity = Quantity FROM Cart WHERE UserId = @UserId AND ProductId = @ProductId;
            
            IF (@AvailableQuantity < (@CurrentQuantity + @Quantity))
                RETURN -6;
            
            UPDATE Cart
            SET Quantity = Quantity + @Quantity,
                UnitPrice = @CurrentPrice,
                UpdatedAt = GETDATE()
            WHERE UserId = @UserId AND ProductId = @ProductId;
        END
        ELSE
        BEGIN
            -- Insert new cart item
            INSERT INTO Cart (UserId, ProductId, Quantity, UnitPrice)
            VALUES (@UserId, @ProductId, @Quantity, @CurrentPrice);
        END
        
        RETURN 1;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- Log error details
        -- INSERT INTO ErrorLog (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState, ProcedureName)
        -- VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_AddToCart');
        
        RETURN -99;
    END CATCH
END;
GO