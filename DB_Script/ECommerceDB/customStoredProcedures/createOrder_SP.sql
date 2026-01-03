DROP PROCEDURE IF EXISTS usp_CreateOrder;
GO
-- =============================================
-- Create Order Procedure
-- =============================================
CREATE PROCEDURE usp_CreateOrder
(
    @UserId INT,
    @ShippingAddressId INT,
    @BillingAddressId INT,
    @PaymentMethodId INT,
    @OrderItems NVARCHAR(MAX), -- JSON array of order items: [{"ProductId":"P001","Quantity":2}]
    @OrderNumber VARCHAR(50) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @OrderId INT;
        DECLARE @Subtotal DECIMAL(18, 2) = 0;
        DECLARE @TaxAmount DECIMAL(18, 2) = 0;
        DECLARE @ShippingAmount DECIMAL(18, 2) = 0;
        DECLARE @TotalAmount DECIMAL(18, 2) = 0;
        DECLARE @CurrentDate DATETIME = GETDATE();
        
        -- Validate inputs
        IF (@UserId IS NULL)
            RETURN -1;
        
        IF (@ShippingAddressId IS NULL OR @BillingAddressId IS NULL)
            RETURN -2;
        
        IF (@OrderItems IS NULL)
            RETURN -3;
        
        -- Validate user and addresses
        IF NOT EXISTS (SELECT 1 FROM Users WHERE UserId = @UserId AND IsActive = 1)
            RETURN -4;
        
        IF NOT EXISTS (SELECT 1 FROM Addresses WHERE AddressId = @ShippingAddressId AND UserId = @UserId)
            RETURN -5;
        
        IF NOT EXISTS (SELECT 1 FROM Addresses WHERE AddressId = @BillingAddressId AND UserId = @UserId)
            RETURN -6;
        
        IF (@PaymentMethodId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PaymentMethods WHERE PaymentMethodId = @PaymentMethodId AND UserId = @UserId AND IsActive = 1))
            RETURN -7;
        
        -- Generate order number
        SET @OrderNumber = 'ORD' + FORMAT(@CurrentDate, 'yyyyMMdd') + RIGHT('000000' + CAST(CAST(@CurrentDate AS FLOAT) * 1000000 AS INT), 6);
        
        -- Begin transaction for order processing
        BEGIN TRANSACTION;
        
        -- Create order record
        INSERT INTO Orders (
            OrderNumber, UserId, OrderStatus, PaymentStatus, PaymentMethodId,
            Subtotal, TaxAmount, ShippingAmount, TotalAmount,
            ShippingAddressId, BillingAddressId, OrderDate
        )
        VALUES (
            @OrderNumber, @UserId, 'Pending', 'Pending', @PaymentMethodId,
            @Subtotal, @TaxAmount, @ShippingAmount, @TotalAmount,
            @ShippingAddressId, @BillingAddressId, @CurrentDate
        );
        
        SET @OrderId = SCOPE_IDENTITY();
        
        -- Process order items from JSON
        DECLARE @JsonItems TABLE (
            ProductId VARCHAR(20),
            Quantity INT
        );
        
        -- Parse JSON order items
        INSERT INTO @JsonItems (ProductId, Quantity)
        SELECT 
            JSON_VALUE(value, '$.ProductId'),
            CAST(JSON_VALUE(value, '$.Quantity') AS INT)
        FROM OPENJSON(@OrderItems);
        
        -- Validate and process each order item using set-based operations
        -- Validate all products exist and are active
        IF EXISTS (
            SELECT 1 FROM @JsonItems ji
            LEFT JOIN Products p ON ji.ProductId = p.ProductId AND p.IsActive = 1
            WHERE p.ProductId IS NULL
        )
        BEGIN
            ROLLBACK TRANSACTION;
            RETURN -8;
        END;
        
        -- Check inventory availability for all items
        IF EXISTS (
            SELECT 1 FROM @JsonItems ji
            INNER JOIN Inventory i ON ji.ProductId = i.ProductId
            WHERE (i.QuantityAvailable - i.QuantityReserved) < ji.Quantity
        )
        BEGIN
            ROLLBACK TRANSACTION;
            RETURN -9;
        END;
        
        -- Insert all order items in one operation
        INSERT INTO OrderItems (OrderId, ProductId, Quantity, UnitPrice, TotalPrice, ProductName, ProductImage)
        SELECT 
            @OrderId,
            ji.ProductId,
            ji.Quantity,
            p.Price,
            p.Price * ji.Quantity,
            p.ProductName,
            p.ImageUrl
        FROM @JsonItems ji
        INNER JOIN Products p ON ji.ProductId = p.ProductId;
        
        -- Calculate subtotal
        SELECT @Subtotal = SUM(TotalPrice)
        FROM OrderItems
        WHERE OrderId = @OrderId;
        
        -- Calculate tax and shipping (simplified logic)
        SET @TaxAmount = @Subtotal * 0.08; -- 8% tax
        SET @ShippingAmount = CASE WHEN @Subtotal >= 100 THEN 0 ELSE 9.99 END; -- Free shipping over $100
        SET @TotalAmount = @Subtotal + @TaxAmount + @ShippingAmount;
        
        -- Update order with calculated totals
        UPDATE Orders
        SET Subtotal = @Subtotal,
            TaxAmount = @TaxAmount,
            ShippingAmount = @ShippingAmount,
            TotalAmount = @TotalAmount
        WHERE OrderId = @OrderId;
        
        COMMIT TRANSACTION;
        
        RETURN @OrderId;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        -- Log error details
        -- INSERT INTO ErrorLog (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState, ProcedureName)
        -- VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_CreateOrder');
        
        RETURN -99;
    END CATCH
END;
GO