-- =============================================
-- Product Details View
-- =============================================
CREATE VIEW vw_ProductDetails
AS
SELECT 
    p.ProductId,
    p.ProductName,
    p.Description,
    p.ShortDescription,
    p.SKU,
    p.Price,
    p.ComparePrice,
    dbo.fn_GetDiscountedPrice(p.ProductId) AS DiscountedPrice,
    p.CategoryId,
    c.CategoryName,
    p.Brand,
    p.Weight,
    p.Dimensions,
    p.Color,
    p.Size,
    p.ImageUrl,
    p.AdditionalImages,
    p.Tags,
    p.IsActive,
    p.IsFeatured,
    p.CreatedAt,
    p.UpdatedAt,
    ISNULL(dbo.fn_GetProductAverageRating(p.ProductId), 0) AS AverageRating,
    ISNULL((SELECT COUNT(*) FROM ProductReviews pr WHERE pr.ProductId = p.ProductId AND pr.IsApproved = 1), 0) AS ReviewCount,
    ISNULL(i.QuantityAvailable, 0) AS QuantityAvailable,
    ISNULL(i.QuantityReserved, 0) AS QuantityReserved,
    dbo.fn_GetProductStockStatus(p.ProductId) AS StockStatus
FROM Products p
INNER JOIN Categories c ON p.CategoryId = c.CategoryId
LEFT JOIN Inventory i ON p.ProductId = i.ProductId;
GO

-- =============================================
-- User Order History View
-- =============================================
CREATE VIEW vw_UserOrderHistory
AS
SELECT 
    o.OrderId,
    o.OrderNumber,
    o.UserId,
    u.FullName,
    u.Email,
    o.OrderStatus,
    o.PaymentStatus,
    o.Subtotal,
    o.TaxAmount,
    o.ShippingAmount,
    o.DiscountAmount,
    o.TotalAmount,
    o.Currency,
    o.OrderDate,
    o.ShippedDate,
    o.DeliveredDate,
    o.TrackingNumber,
    o.Notes,
    COUNT(oi.OrderItemId) AS ItemCount,
    pm.MethodType AS PaymentMethod
FROM Orders o
INNER JOIN Users u ON o.UserId = u.UserId
LEFT JOIN PaymentMethods pm ON o.PaymentMethodId = pm.PaymentMethodId
LEFT JOIN OrderItems oi ON o.OrderId = oi.OrderId
GROUP BY 
    o.OrderId, o.OrderNumber, o.UserId, u.FullName, u.Email, o.OrderStatus, 
    o.PaymentStatus, o.Subtotal, o.TaxAmount, o.ShippingAmount, o.DiscountAmount, 
    o.TotalAmount, o.Currency, o.OrderDate, o.ShippedDate, o.DeliveredDate, 
    o.TrackingNumber, o.Notes, pm.MethodType;
GO

-- =============================================
-- Order Details View
-- =============================================
CREATE VIEW vw_OrderDetails
AS
SELECT 
    o.OrderId,
    o.OrderNumber,
    o.UserId,
    u.FullName,
    u.Email,
    o.OrderStatus,
    o.PaymentStatus,
    o.Subtotal,
    o.TaxAmount,
    o.ShippingAmount,
    o.DiscountAmount,
    o.TotalAmount,
    o.Currency,
    o.OrderDate,
    o.ShippedDate,
    o.DeliveredDate,
    o.TrackingNumber,
    o.Notes,
    oi.OrderItemId,
    oi.ProductId,
    oi.ProductName,
    oi.Quantity,
    oi.UnitPrice,
    oi.TotalPrice,
    oi.ProductImage,
    sa.AddressLine1 AS ShippingAddressLine1,
    sa.City AS ShippingCity,
    sa.State AS ShippingState,
    sa.PostalCode AS ShippingPostalCode,
    sa.Country AS ShippingCountry,
    ba.AddressLine1 AS BillingAddressLine1,
    ba.City AS BillingCity,
    ba.State AS BillingState,
    ba.PostalCode AS BillingPostalCode,
    ba.Country AS BillingCountry,
    pm.MethodType AS PaymentMethod
FROM Orders o
INNER JOIN Users u ON o.UserId = u.UserId
INNER JOIN OrderItems oi ON o.OrderId = oi.OrderId
INNER JOIN Addresses sa ON o.ShippingAddressId = sa.AddressId
INNER JOIN Addresses ba ON o.BillingAddressId = ba.AddressId
LEFT JOIN PaymentMethods pm ON o.PaymentMethodId = pm.PaymentMethodId;
GO

-- =============================================
-- Category Products View
-- =============================================
CREATE VIEW vw_CategoryProducts
AS
SELECT 
    c.CategoryId,
    c.CategoryName,
    c.Description,
    c.ParentCategoryId,
    c.ImageUrl,
    c.IsActive,
    c.SortOrder,
    p.ProductId,
    p.ProductName,
    p.Price,
    p.ComparePrice,
    dbo.fn_GetDiscountedPrice(p.ProductId) AS DiscountedPrice,
    p.ImageUrl AS ProductImage,
    p.IsFeatured,
    ISNULL(dbo.fn_GetProductAverageRating(p.ProductId), 0) AS AverageRating,
    ISNULL(i.QuantityAvailable, 0) AS QuantityAvailable,
    dbo.fn_GetProductStockStatus(p.ProductId) AS StockStatus,
    dbo.fn_GetCategoryProductCount(c.CategoryId) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON c.CategoryId = p.CategoryId AND p.IsActive = 1
LEFT JOIN Inventory i ON p.ProductId = i.ProductId
WHERE c.IsActive = 1;
GO

-- =============================================
-- User Dashboard View
-- =============================================
CREATE VIEW vw_UserDashboard
AS
SELECT 
    u.UserId,
    u.FullName,
    u.Email,
    u.CreatedAt,
    dbo.fn_GetUserTotalOrders(u.UserId) AS TotalOrders,
    dbo.fn_GetUserTotalSpent(u.UserId) AS TotalSpent,
    ISNULL((SELECT COUNT(*) FROM Cart c WHERE c.UserId = u.UserId), 0) AS CartItems,
    ISNULL((SELECT COUNT(*) FROM WishList w WHERE w.UserId = u.UserId), 0) AS WishListItems,
    ISNULL((SELECT COUNT(*) FROM ProductReviews pr WHERE pr.UserId = u.UserId AND pr.IsApproved = 1), 0) AS ReviewCount,
    (SELECT TOP 1 o.OrderDate FROM Orders o WHERE o.UserId = u.UserId ORDER BY o.OrderDate DESC) AS LastOrderDate
FROM Users u
WHERE u.IsActive = 1;
GO

-- =============================================
-- Sales Report View
-- =============================================
CREATE VIEW vw_SalesReport
AS
SELECT 
    YEAR(o.OrderDate) AS OrderYear,
    MONTH(o.OrderDate) AS OrderMonth,
    DAY(o.OrderDate) AS OrderDay,
    COUNT(o.OrderId) AS OrderCount,
    SUM(o.TotalAmount) AS TotalRevenue,
    AVG(o.TotalAmount) AS AverageOrderValue,
    COUNT(DISTINCT o.UserId) AS UniqueCustomers,
    COUNT(DISTINCT oi.ProductId) AS UniqueProductsSold
FROM Orders o
INNER JOIN OrderItems oi ON o.OrderId = oi.OrderId
WHERE o.OrderStatus NOT IN ('Cancelled', 'Refunded')
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), DAY(o.OrderDate);
GO