-- =============================================
-- Get Product Average Rating Function
-- =============================================
CREATE FUNCTION dbo.fn_GetProductAverageRating(@ProductId VARCHAR(20))
RETURNS DECIMAL(3, 1)
AS
BEGIN
    DECLARE @AverageRating DECIMAL(3, 1);
    
    SELECT @AverageRating = ISNULL(AVG(CAST(Rating AS DECIMAL(3, 1))), 0)
    FROM ProductReviews
    WHERE ProductId = @ProductId AND IsApproved = 1;
    
    RETURN @AverageRating;
END;
GO

-- =============================================
-- Get User Total Orders Function
-- =============================================
CREATE FUNCTION dbo.fn_GetUserTotalOrders(@UserId INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalOrders INT;
    
    SELECT @TotalOrders = COUNT(*)
    FROM Orders
    WHERE UserId = @UserId AND OrderStatus NOT IN ('Cancelled', 'Refunded');
    
    RETURN @TotalOrders;
END;
GO

-- =============================================
-- Get User Total Spent Function
-- =============================================
CREATE FUNCTION dbo.fn_GetUserTotalSpent(@UserId INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @TotalSpent DECIMAL(18, 2);
    
    SELECT @TotalSpent = ISNULL(SUM(TotalAmount), 0)
    FROM Orders
    WHERE UserId = @UserId AND OrderStatus NOT IN ('Cancelled', 'Refunded');
    
    RETURN @TotalSpent;
END;
GO

-- =============================================
-- Get Product Stock Status Function
-- =============================================
CREATE FUNCTION dbo.fn_GetProductStockStatus(@ProductId VARCHAR(20))
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @AvailableQuantity INT;
    DECLARE @ReorderLevel INT;
    DECLARE @StockStatus NVARCHAR(20);
    
    SELECT 
        @AvailableQuantity = (QuantityAvailable - QuantityReserved),
        @ReorderLevel = ReorderLevel
    FROM Inventory
    WHERE ProductId = @ProductId;
    
    IF @AvailableQuantity = 0
        SET @StockStatus = 'Out of Stock';
    ELSE IF @AvailableQuantity <= @ReorderLevel
        SET @StockStatus = 'Low Stock';
    ELSE
        SET @StockStatus = 'In Stock';
    
    RETURN @StockStatus;
END;
GO

-- =============================================
-- Calculate Order Total Function
-- =============================================
CREATE FUNCTION dbo.fn_CalculateOrderTotal(@OrderId INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @OrderTotal DECIMAL(18, 2);
    
    SELECT @OrderTotal = ISNULL(SUM(TotalPrice), 0)
    FROM OrderItems
    WHERE OrderId = @OrderId;
    
    RETURN @OrderTotal;
END;
GO

-- =============================================
-- Get Cart Total Function
-- =============================================
CREATE FUNCTION dbo.fn_GetCartTotal(@UserId INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @CartTotal DECIMAL(18, 2);
    
    SELECT @CartTotal = ISNULL(SUM(Quantity * UnitPrice), 0)
    FROM Cart
    WHERE UserId = @UserId;
    
    RETURN @CartTotal;
END;
GO

-- =============================================
-- Get Category Product Count Function
-- =============================================
CREATE FUNCTION dbo.fn_GetCategoryProductCount(@CategoryId INT)
RETURNS INT
AS
BEGIN
    DECLARE @ProductCount INT;
    
    SELECT @ProductCount = COUNT(*)
    FROM Products
    WHERE CategoryId = @CategoryId AND IsActive = 1;
    
    RETURN @ProductCount;
END;
GO

-- =============================================
-- Get Discounted Price Function
-- =============================================
CREATE FUNCTION dbo.fn_GetDiscountedPrice(@ProductId VARCHAR(20))
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @Price DECIMAL(18, 2);
    DECLARE @ComparePrice DECIMAL(18, 2);
    DECLARE @FinalPrice DECIMAL(18, 2);

    SELECT 
        @Price = Price,
        @ComparePrice = ComparePrice
    FROM Products
    WHERE ProductId = @ProductId;

    -- Determine the final price
    IF @ComparePrice IS NOT NULL AND @ComparePrice < @Price
        SET @FinalPrice = @ComparePrice;
    ELSE
        SET @FinalPrice = @Price;

    RETURN @FinalPrice;
END;
GO