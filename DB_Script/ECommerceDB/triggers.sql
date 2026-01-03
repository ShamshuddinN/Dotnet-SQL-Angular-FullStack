-- =============================================
-- Database Triggers for Data Integrity
-- =============================================

-- Trigger to update UpdatedAt timestamp on Users table
CREATE TRIGGER trg_UpdateUserTimestamp
ON Users
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Users
    SET UpdatedAt = GETDATE()
    FROM Users U
    INNER JOIN inserted i ON U.UserId = i.UserId;
END
GO

-- Trigger to update UpdatedAt timestamp on Products table
CREATE TRIGGER trg_UpdateProductTimestamp
ON Products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Products
    SET UpdatedAt = GETDATE()
    FROM Products P
    INNER JOIN inserted i ON P.ProductId = i.ProductId;
END
GO

-- Trigger to update UpdatedAt timestamp on Categories table
CREATE TRIGGER trg_UpdateCategoryTimestamp
ON Categories
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Categories
    SET UpdatedAt = GETDATE()
    FROM Categories C
    INNER JOIN inserted i ON C.CategoryId = i.CategoryId;
END
GO

-- Trigger to update inventory when order is placed
CREATE TRIGGER trg_UpdateInventoryOnOrder
ON OrderItems
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Reserve inventory for ordered items
    UPDATE I
    SET I.QuantityReserved = I.QuantityReserved + ins.Quantity,
        I.LastStockUpdate = GETDATE()
    FROM Inventory I
    INNER JOIN inserted ins ON I.ProductId = ins.ProductId;
END
GO

-- Trigger to update inventory when order is confirmed/shipped
CREATE TRIGGER trg_UpdateInventoryOnOrderStatus
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- If order status changed to 'Shipped', move from reserved to available
    IF UPDATE(OrderStatus)
    BEGIN
        UPDATE I
        SET I.QuantityAvailable = I.QuantityAvailable - oi.Quantity,
            I.QuantityReserved = I.QuantityReserved - oi.Quantity,
            I.LastStockUpdate = GETDATE()
        FROM Inventory I
        INNER JOIN OrderItems oi ON I.ProductId = oi.ProductId
        INNER JOIN inserted o ON oi.OrderId = o.OrderId
        WHERE o.OrderStatus = 'Shipped'
        AND EXISTS (
            SELECT 1 FROM deleted d 
            WHERE d.OrderId = o.OrderId 
            AND d.OrderStatus <> 'Shipped'
        );
        
        -- If order was cancelled, release reserved inventory
        UPDATE I
        SET I.QuantityReserved = I.QuantityReserved - oi.Quantity,
            I.LastStockUpdate = GETDATE()
        FROM Inventory I
        INNER JOIN OrderItems oi ON I.ProductId = oi.ProductId
        INNER JOIN inserted o ON oi.OrderId = o.OrderId
        WHERE o.OrderStatus = 'Cancelled'
        AND EXISTS (
            SELECT 1 FROM deleted d 
            WHERE d.OrderId = o.OrderId 
            AND d.OrderStatus <> 'Cancelled'
        );
    END
END
GO

-- Trigger to update product average rating
CREATE TRIGGER trg_UpdateProductRating
ON ProductReviews
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update product rating when reviews are added, updated, or deleted
    UPDATE P
    SET P.AverageRating = ISNULL(
        (SELECT CAST(AVG(CAST(Rating AS DECIMAL(3,1))) AS DECIMAL(3,1))
         FROM ProductReviews PR 
         WHERE PR.ProductId = P.ProductId 
         AND PR.IsApproved = 1), 0)
    FROM Products P
    WHERE P.ProductId IN (
        SELECT ProductId FROM inserted
        UNION
        SELECT ProductId FROM deleted
    );
END
GO

-- Trigger to validate cart quantities
CREATE TRIGGER trg_ValidateCartQuantity
ON Cart
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if requested quantity is available
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        INNER JOIN Inventory inv ON i.ProductId = inv.ProductId
        WHERE i.Quantity > (inv.QuantityAvailable - inv.QuantityReserved)
    )
    BEGIN
        RAISERROR('Insufficient inventory for requested quantity', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO

-- Trigger to maintain only one default address per user per type
CREATE TRIGGER trg_MaintainDefaultAddress
ON Addresses
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- If new/updated address is set as default, unset other defaults
    IF EXISTS (SELECT 1 FROM inserted WHERE IsDefault = 1)
    BEGIN
        UPDATE A
        SET A.IsDefault = 0
        FROM Addresses A
        INNER JOIN inserted i ON A.UserId = i.UserId AND A.AddressType = i.AddressType
        WHERE i.IsDefault = 1
        AND A.AddressId NOT IN (SELECT AddressId FROM inserted WHERE IsDefault = 1);
    END
END
GO

-- Trigger to maintain only one default payment method per user
CREATE TRIGGER trg_MaintainDefaultPaymentMethod
ON PaymentMethods
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- If new/updated payment method is set as default, unset other defaults
    IF EXISTS (SELECT 1 FROM inserted WHERE IsDefault = 1)
    BEGIN
        UPDATE PM
        SET PM.IsDefault = 0
        FROM PaymentMethods PM
        INNER JOIN inserted i ON PM.UserId = i.UserId
        WHERE i.IsDefault = 1
        AND PM.PaymentMethodId NOT IN (SELECT PaymentMethodId FROM inserted WHERE IsDefault = 1);
    END
END
GO