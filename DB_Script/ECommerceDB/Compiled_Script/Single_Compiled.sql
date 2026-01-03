--Run this only after running refreshScripts.sql
-- =============================================
-- E-Commerce Database Schema
-- =============================================

-- Create Roles table
CREATE TABLE Roles (
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL,
    CreatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time'
);
GO

-- Create Users table
CREATE TABLE Users (
    UserId INT IDENTITY(1000,1) PRIMARY KEY,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(255) NOT NULL,
    ProfileImgPath NVARCHAR(255) NULL,
    [Gender] CHAR(1) CONSTRAINT chk_Gender CHECK(Gender='F' OR Gender='M' OR Gender='O') NOT NULL,
    [DateOfBirth] DATE CONSTRAINT chk_DateOfBirth CHECK(DateOfBirth<GETDATE()) NOT NULL,
    RoleId INT NOT NULL,
    PhoneNumber NVARCHAR(20) NULL,
    IsActive BIT DEFAULT 1,
    EmailVerified BIT DEFAULT 0,
    CreatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    UpdatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    LastLoginAt DATETIME2(7) NULL,
    FOREIGN KEY (RoleId) REFERENCES Roles(RoleId)
);
GO

-- Create Addresses table
CREATE TABLE Addresses (
    AddressId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    AddressLine1 NVARCHAR(255) NOT NULL,
    AddressLine2 NVARCHAR(255) NULL,
    City NVARCHAR(100) NOT NULL,
    State NVARCHAR(100) NOT NULL,
    PostalCode NVARCHAR(20) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    AddressType NVARCHAR(20) NOT NULL CHECK(AddressType IN ('Billing', 'Shipping', 'Both')),
    IsDefault BIT DEFAULT 0,
    CreatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    UpdatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE
);
GO

-- Create Categories table
CREATE TABLE Categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(MAX) NULL,
    ParentCategoryId INT NULL,
    ImageUrl NVARCHAR(255) NULL,
    IsActive BIT DEFAULT 1,
    SortOrder INT DEFAULT 0,
    CreatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    UpdatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    FOREIGN KEY (ParentCategoryId) REFERENCES Categories(CategoryId)
);
GO

-- Create Products table
CREATE TABLE Products (
    ProductId VARCHAR(20) PRIMARY KEY,
    ProductName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    ShortDescription NVARCHAR(500) NULL,
    SKU VARCHAR(50) NOT NULL UNIQUE,
    Price DECIMAL(18, 2) NOT NULL,
    ComparePrice DECIMAL(18, 2) NULL,
    CostPrice DECIMAL(18, 2) NULL,
    CategoryId INT NOT NULL,
    Brand NVARCHAR(100) NULL,
    Weight DECIMAL(10, 3) NULL,
    Dimensions NVARCHAR(50) NULL,
    Color NVARCHAR(50) NULL,
    Size NVARCHAR(50) NULL,
    ImageUrl NVARCHAR(255) NULL,
    AdditionalImages NVARCHAR(MAX) NULL, -- JSON array of additional images
    Tags NVARCHAR(MAX) NULL, -- JSON array of tags
    IsActive BIT DEFAULT 1,
    IsFeatured BIT DEFAULT 0,
    TrackInventory BIT DEFAULT 1,
    AverageRating DECIMAL(3, 1) NOT NULL DEFAULT 0, -- Added AverageRating column
    CreatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    UpdatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId)
);
GO

-- Create Inventory table
CREATE TABLE Inventory (
    InventoryId INT IDENTITY(1,1) PRIMARY KEY,
    ProductId VARCHAR(20) NOT NULL UNIQUE,
    QuantityAvailable INT NOT NULL DEFAULT 0,
    QuantityReserved INT NOT NULL DEFAULT 0,
    QuantityOnOrder INT NOT NULL DEFAULT 0,
    ReorderLevel INT NOT NULL DEFAULT 10,
    ReorderQuantity INT NOT NULL DEFAULT 50,
    LastStockUpdate DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE
);
GO

-- Create ProductReviews table
CREATE TABLE ProductReviews (
    ReviewId INT IDENTITY(1,1) PRIMARY KEY,
    ProductId VARCHAR(20) NOT NULL,
    UserId INT NOT NULL,
    Rating INT NOT NULL CHECK(Rating >= 1 AND Rating <= 5),
    Title NVARCHAR(255) NULL,
    ReviewText NVARCHAR(MAX) NOT NULL,
    IsVerified BIT DEFAULT 0,
    IsApproved BIT DEFAULT 1,
    HelpfulCount INT DEFAULT 0,
    CreatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    UpdatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    CONSTRAINT UC_ProductUser UNIQUE (ProductId, UserId)
);
GO

-- Create PaymentMethods table
CREATE TABLE PaymentMethods (
    PaymentMethodId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    MethodType NVARCHAR(50) NOT NULL CHECK(MethodType IN ('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'Cash on Delivery')),
    Provider NVARCHAR(100) NOT NULL,
    AccountNumber NVARCHAR(255) NOT NULL,
    ExpiryDate DATE NULL,
    CardholderName NVARCHAR(255) NULL,
    IsDefault BIT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    UpdatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE
);
GO

-- Create Cart table
CREATE TABLE Cart (
    CartId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    ProductId VARCHAR(20) NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    UnitPrice DECIMAL(18, 2) NOT NULL,
    AddedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    UpdatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE,
    CONSTRAINT UC_CartUserProduct UNIQUE (UserId, ProductId)
);
GO

-- Create WishList table
CREATE TABLE WishList (
    WishListId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    ProductId VARCHAR(20) NOT NULL,
    AddedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE,
    CONSTRAINT UC_WishListUserProduct UNIQUE (UserId, ProductId)
);
GO

-- Create Orders table
CREATE TABLE Orders (
    OrderId INT IDENTITY(1,1) PRIMARY KEY,
    OrderNumber VARCHAR(50) NOT NULL UNIQUE,
    UserId INT NOT NULL,
    OrderStatus NVARCHAR(50) NOT NULL CHECK(OrderStatus IN ('Pending', 'Confirmed', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Refunded')),
    PaymentStatus NVARCHAR(50) NOT NULL CHECK(PaymentStatus IN ('Pending', 'Paid', 'Failed', 'Refunded', 'Partially Refunded')),
    PaymentMethodId INT NULL,
    Subtotal DECIMAL(18, 2) NOT NULL,
    TaxAmount DECIMAL(18, 2) NOT NULL DEFAULT 0,
    ShippingAmount DECIMAL(18, 2) NOT NULL DEFAULT 0,
    DiscountAmount DECIMAL(18, 2) NOT NULL DEFAULT 0,
    TotalAmount DECIMAL(18, 2) NOT NULL,
    Currency NVARCHAR(3) NOT NULL DEFAULT 'USD',
    ShippingAddressId INT NOT NULL,
    BillingAddressId INT NOT NULL,
    OrderDate DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    ShippedDate DATETIME2(7) NULL,
    DeliveredDate DATETIME2(7) NULL,
    TrackingNumber NVARCHAR(100) NULL,
    Notes NVARCHAR(MAX) NULL,
    CreatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    UpdatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (PaymentMethodId) REFERENCES PaymentMethods(PaymentMethodId),
    FOREIGN KEY (ShippingAddressId) REFERENCES Addresses(AddressId),
    FOREIGN KEY (BillingAddressId) REFERENCES Addresses(AddressId)
);
GO

-- Create OrderItems table
CREATE TABLE OrderItems (
    OrderItemId INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL,
    ProductId VARCHAR(20) NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18, 2) NOT NULL,
    TotalPrice DECIMAL(18, 2) NOT NULL,
    ProductName NVARCHAR(255) NOT NULL, -- Denormalized for historical purposes
    ProductImage NVARCHAR(255) NULL, -- Denormalized for historical purposes
    CreatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);
GO

-- Create OrderReviews table
CREATE TABLE OrderReviews (
    OrderReviewId INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL UNIQUE,
    UserId INT NOT NULL,
    OverallRating INT NOT NULL CHECK(OverallRating >= 1 AND OverallRating <= 5),
    ServiceRating INT NULL CHECK(ServiceRating >= 1 AND ServiceRating <= 5),
    DeliveryRating INT NULL CHECK(DeliveryRating >= 1 AND DeliveryRating <= 5),
    ReviewText NVARCHAR(MAX) NULL,
    IsPublic BIT DEFAULT 1,
    CreatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    UpdatedAt DATETIME2(7) DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE
);
GO

-- Create ErrorLog table
CREATE TABLE ErrorLog (
    ErrorLogId INT IDENTITY(1,1) PRIMARY KEY,
    ErrorTime DATETIME DEFAULT SYSDATETIMEOFFSET() AT TIME ZONE 'India Standard Time',
    ErrorMessage NVARCHAR(4000) NOT NULL,
    ErrorSeverity INT NOT NULL,
    ErrorState INT NOT NULL,
    ErrorProcedure NVARCHAR(128) NULL,
    ErrorLine INT NULL,
    UserName NVARCHAR(128) DEFAULT SUSER_SNAME(),
    HostName NVARCHAR(128) DEFAULT HOST_NAME()
);
GO


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

-- =============================================
-- Performance Optimization Indexes
-- =============================================

-- Users table indexes
CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_Users_RoleId ON Users(RoleId);
CREATE INDEX IX_Users_IsActive ON Users(IsActive);
CREATE INDEX IX_Users_CreatedAt ON Users(CreatedAt);
GO

-- Products table indexes
CREATE INDEX IX_Products_CategoryId ON Products(CategoryId);
CREATE INDEX IX_Products_IsActive ON Products(IsActive);
CREATE INDEX IX_Products_IsFeatured ON Products(IsFeatured);
CREATE INDEX IX_Products_Price ON Products(Price);
CREATE INDEX IX_Products_SKU ON Products(SKU);
CREATE INDEX IX_Products_Brand ON Products(Brand);
CREATE INDEX IX_Products_CreatedAt ON Products(CreatedAt);
-- Full-text index for product search
CREATE FULLTEXT CATALOG ft_catalog AS DEFAULT;
CREATE UNIQUE INDEX IX_Products_FTSKey ON Products(SKU);
CREATE FULLTEXT INDEX ON Products(ProductName, Description, ShortDescription, Tags) 
KEY INDEX IX_Products_FTSKey WITH STOPLIST = SYSTEM;
GO

-- Categories table indexes
CREATE INDEX IX_Categories_ParentCategoryId ON Categories(ParentCategoryId);
CREATE INDEX IX_Categories_IsActive ON Categories(IsActive);
CREATE INDEX IX_Categories_SortOrder ON Categories(SortOrder);
GO

-- Inventory table indexes
CREATE INDEX IX_Inventory_QuantityAvailable ON Inventory(QuantityAvailable);
CREATE INDEX IX_Inventory_LastStockUpdate ON Inventory(LastStockUpdate);
GO

-- ProductReviews table indexes
CREATE INDEX IX_ProductReviews_ProductId ON ProductReviews(ProductId);
CREATE INDEX IX_ProductReviews_UserId ON ProductReviews(UserId);
CREATE INDEX IX_ProductReviews_Rating ON ProductReviews(Rating);
CREATE INDEX IX_ProductReviews_IsApproved ON ProductReviews(IsApproved);
CREATE INDEX IX_ProductReviews_CreatedAt ON ProductReviews(CreatedAt);
GO

-- Cart table indexes
CREATE INDEX IX_Cart_UserId ON Cart(UserId);
CREATE INDEX IX_Cart_AddedAt ON Cart(AddedAt);
GO

-- Orders table indexes
CREATE INDEX IX_Orders_UserId ON Orders(UserId);
CREATE INDEX IX_Orders_OrderStatus ON Orders(OrderStatus);
CREATE INDEX IX_Orders_PaymentStatus ON Orders(PaymentStatus);
CREATE INDEX IX_Orders_OrderDate ON Orders(OrderDate);
CREATE INDEX IX_Orders_TotalAmount ON Orders(TotalAmount);
GO

-- OrderItems table indexes
CREATE INDEX IX_OrderItems_OrderId ON OrderItems(OrderId);
CREATE INDEX IX_OrderItems_ProductId ON OrderItems(ProductId);
GO

-- Addresses table indexes
CREATE INDEX IX_Addresses_UserId ON Addresses(UserId);
CREATE INDEX IX_Addresses_AddressType ON Addresses(AddressType);
CREATE INDEX IX_Addresses_IsDefault ON Addresses(IsDefault);
GO

-- PaymentMethods table indexes
CREATE INDEX IX_PaymentMethods_UserId ON PaymentMethods(UserId);
CREATE INDEX IX_PaymentMethods_IsDefault ON PaymentMethods(IsDefault);
CREATE INDEX IX_PaymentMethods_IsActive ON PaymentMethods(IsActive);
GO

-- WishList table indexes
CREATE INDEX IX_WishList_UserId ON WishList(UserId);
CREATE INDEX IX_WishList_AddedAt ON WishList(AddedAt);
GO

-- OrderReviews table indexes
CREATE INDEX IX_OrderReviews_OrderId ON OrderReviews(OrderId);
CREATE INDEX IX_OrderReviews_UserId ON OrderReviews(UserId);
CREATE INDEX IX_OrderReviews_OverallRating ON OrderReviews(OverallRating);
GO

-- Additional composite indexes for common query patterns
CREATE INDEX IX_Products_Category_IsActive ON Products(CategoryId, IsActive);
CREATE INDEX IX_Products_IsActive_IsFeatured ON Products(IsActive, IsFeatured);
CREATE INDEX IX_Orders_User_Status ON Orders(UserId, OrderStatus);
CREATE INDEX IX_Orders_Status_Date ON Orders(OrderStatus, OrderDate);
CREATE INDEX IX_Cart_User_Product ON Cart(UserId, ProductId);
CREATE INDEX IX_OrderItems_Order_Product ON OrderItems(OrderId, ProductId);
CREATE INDEX IX_ProductReviews_Product_Approved ON ProductReviews(ProductId, IsApproved);
CREATE INDEX IX_Addresses_User_Type_Default ON Addresses(UserId, AddressType, IsDefault);
GO

-- Index for error log queries
CREATE INDEX IX_ErrorLog_ErrorTime ON ErrorLog(ErrorTime);
CREATE INDEX IX_ErrorLog_ErrorProcedure ON ErrorLog(ErrorProcedure);
GO



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
    CASE 
        WHEN p.ComparePrice IS NOT NULL AND p.ComparePrice < p.Price THEN p.ComparePrice
        ELSE p.Price
    END AS DiscountedPrice,
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
    p.AverageRating, -- Use the persisted column maintained by trigger
    ISNULL((SELECT COUNT(*) FROM ProductReviews pr WHERE pr.ProductId = p.ProductId AND pr.IsApproved = 1), 0) AS ReviewCount,
    ISNULL(i.QuantityAvailable, 0) AS QuantityAvailable,
    ISNULL(i.QuantityReserved, 0) AS QuantityReserved,
    CASE 
        WHEN (ISNULL(i.QuantityAvailable, 0) - ISNULL(i.QuantityReserved, 0)) = 0 THEN 'Out of Stock'
        WHEN (ISNULL(i.QuantityAvailable, 0) - ISNULL(i.QuantityReserved, 0)) <= ISNULL(i.ReorderLevel, 10) THEN 'Low Stock'
        ELSE 'In Stock'
    END AS StockStatus
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
    CASE 
        WHEN p.ComparePrice IS NOT NULL AND p.ComparePrice < p.Price THEN p.ComparePrice
        ELSE p.Price
    END AS DiscountedPrice,
    p.ImageUrl AS ProductImage,
    p.IsFeatured,
    p.AverageRating, -- Use persisted calc
    ISNULL(i.QuantityAvailable, 0) AS QuantityAvailable,
    CASE 
        WHEN (ISNULL(i.QuantityAvailable, 0) - ISNULL(i.QuantityReserved, 0)) = 0 THEN 'Out of Stock'
        WHEN (ISNULL(i.QuantityAvailable, 0) - ISNULL(i.QuantityReserved, 0)) <= ISNULL(i.ReorderLevel, 10) THEN 'Low Stock'
        ELSE 'In Stock'
    END AS StockStatus,
    COUNT(p.ProductId) OVER (PARTITION BY c.CategoryId) AS ProductCount
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
    ISNULL(o_stats.TotalOrders, 0) AS TotalOrders,
    ISNULL(o_stats.TotalSpent, 0) AS TotalSpent,
    ISNULL(c_stats.CartItems, 0) AS CartItems,
    ISNULL(w_stats.WishListItems, 0) AS WishListItems,
    ISNULL(r_stats.ReviewCount, 0) AS ReviewCount,
    o_stats.LastOrderDate
FROM Users u
OUTER APPLY (
    SELECT 
        COUNT(*) AS TotalOrders, 
        SUM(TotalAmount) AS TotalSpent,
        MAX(OrderDate) AS LastOrderDate
    FROM Orders o 
    WHERE o.UserId = u.UserId AND o.OrderStatus NOT IN ('Cancelled', 'Refunded')
) o_stats
OUTER APPLY (
    SELECT COUNT(*) AS CartItems FROM Cart c WHERE c.UserId = u.UserId
) c_stats
OUTER APPLY (
    SELECT COUNT(*) AS WishListItems FROM WishList w WHERE w.UserId = u.UserId
) w_stats
OUTER APPLY (
    SELECT COUNT(*) AS ReviewCount FROM ProductReviews pr WHERE pr.UserId = u.UserId AND pr.IsApproved = 1
) r_stats
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
        -- INSERT INTO ErrorLog (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState, ProcedureName)
        -- VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_RegisterUser');
        
        SELECT -99 AS VALUE;
    END CATCH
END;
GO

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
            -- Atomic update using WHERE clause to ensure consistency
            UPDATE Inventory
            SET QuantityAvailable = QuantityAvailable - @QuantityAdjustment,
                LastStockUpdate = GETDATE()
            WHERE ProductId = @ProductId AND QuantityAvailable >= @QuantityAdjustment;

            IF @@ROWCOUNT = 0
                RETURN -5; -- Insufficient quantity or product not found
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

DROP PROCEDURE IF EXISTS usp_InsertProduct;
go
-- =============================================
-- Product Insertion Procedure
-- =============================================
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
        INSERT INTO ErrorLog (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState, ErrorProcedure)
        VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_InsertProduct');
        
        SELECT -99 AS VALUE;
    END CATCH
END;
GO

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
        DECLARE @CurrentDate DATETIME2(7) = GETDATE();
        
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
        SET @OrderNumber = 'ORD' + FORMAT(@CurrentDate, 'yyyyMMddHHmmssffffff');
        
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

DROP PROCEDURE IF EXISTS [dbo].[usp_GetUserCart];
DROP PROCEDURE IF EXISTS [dbo].[usp_RemoveFromCart];
DROP PROCEDURE IF EXISTS [dbo].[usp_ClearCart];
DROP PROCEDURE IF EXISTS [dbo].[usp_AddProductReview];
DROP PROCEDURE IF EXISTS [dbo].[usp_GetProductReviews];
GO
-- =============================================
-- Get User Cart Procedure
-- =============================================

CREATE PROCEDURE usp_GetUserCart
(
    @UserId INT
)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        c.CartId,
        c.ProductId,
        p.ProductName,
        p.Description,
        p.ImageUrl,
        c.Quantity,
        c.UnitPrice,
        c.AddedAt,
        (c.Quantity * c.UnitPrice) AS ItemTotal,
        p.SKU,
        cat.CategoryName,
        (SELECT QuantityAvailable - QuantityReserved FROM Inventory i WHERE i.ProductId = c.ProductId) AS AvailableQuantity
    FROM Cart c
    INNER JOIN Products p ON c.ProductId = p.ProductId
    INNER JOIN Categories cat ON p.CategoryId = cat.CategoryId
    WHERE c.UserId = @UserId
    ORDER BY c.AddedAt DESC;
END;
GO

-- =============================================
-- Remove From Cart Procedure
-- =============================================
CREATE PROCEDURE usp_RemoveFromCart
(
    @UserId INT,
    @ProductId VARCHAR(20),
    @Quantity INT = NULL -- NULL to remove entire item, specific quantity to reduce
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@UserId IS NULL OR @ProductId IS NULL)
            RETURN -1;
        
        IF (@Quantity IS NOT NULL AND @Quantity <= 0)
            RETURN -2;
        
        IF NOT EXISTS (SELECT 1 FROM Cart WHERE UserId = @UserId AND ProductId = @ProductId)
            RETURN -3;
        
        IF (@Quantity IS NULL)
        BEGIN
            -- Remove entire item from cart
            DELETE FROM Cart WHERE UserId = @UserId AND ProductId = @ProductId;
        END
        ELSE
        BEGIN
            -- Check if quantity to remove is valid
            DECLARE @CurrentQuantity INT;
            SELECT @CurrentQuantity = Quantity FROM Cart WHERE UserId = @UserId AND ProductId = @ProductId;
            
            IF (@Quantity >= @CurrentQuantity)
            BEGIN
                -- Remove entire item
                DELETE FROM Cart WHERE UserId = @UserId AND ProductId = @ProductId;
            END
            ELSE
            BEGIN
                -- Reduce quantity
                UPDATE Cart
                SET Quantity = Quantity - @Quantity,
                    UpdatedAt = GETDATE()
                WHERE UserId = @UserId AND ProductId = @ProductId;
            END
        END;
        
        RETURN 1;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- Log error details
        -- INSERT INTO ErrorLog (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState, ProcedureName)
        -- VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_GetUserCart');
        
        RETURN -99;
    END CATCH
END;
GO

-- =============================================
-- Clear Cart Procedure
-- =============================================
CREATE PROCEDURE usp_ClearCart
(
    @UserId INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@UserId IS NULL)
            RETURN -1;
        
        DELETE FROM Cart WHERE UserId = @UserId;
        
        RETURN 1;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- Log error details
        -- INSERT INTO ErrorLog (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState, ProcedureName)
        -- VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_GetUserCart');
        
        RETURN -99;
    END CATCH
END;
GO

-- =============================================
-- Add Product Review Procedure
-- =============================================
CREATE PROCEDURE usp_AddProductReview
(
    @ProductId VARCHAR(20),
    @UserId INT,
    @Rating INT,
    @Title NVARCHAR(255) = NULL,
    @ReviewText NVARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validate inputs
        IF (@ProductId IS NULL OR @UserId IS NULL OR @Rating IS NULL OR @ReviewText IS NULL)
            RETURN -1;
        
        IF (@Rating < 1 OR @Rating > 5)
            RETURN -2;
        
        -- Check if user has purchased the product
        IF NOT EXISTS (
            SELECT 1 FROM Orders o
            INNER JOIN OrderItems oi ON o.OrderId = oi.OrderId
            WHERE o.UserId = @UserId AND oi.ProductId = @ProductId AND o.OrderStatus = 'Delivered'
        )
            RETURN -3; -- User hasn't purchased the product
        
        -- Check if review already exists
        IF EXISTS (SELECT 1 FROM ProductReviews WHERE ProductId = @ProductId AND UserId = @UserId)
            RETURN -4;
        
        -- Insert review
        INSERT INTO ProductReviews (ProductId, UserId, Rating, Title, ReviewText, IsVerified)
        VALUES (@ProductId, @UserId, @Rating, @Title, @ReviewText, 1);
        
        RETURN 1;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- Log error details
        -- INSERT INTO ErrorLog (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState, ProcedureName)
        -- VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_GetUserCart');
        
        RETURN -99;
    END CATCH
END;
GO

-- =============================================
-- Get Product Reviews Procedure
-- =============================================
CREATE PROCEDURE usp_GetProductReviews
(
    @ProductId VARCHAR(20),
    @PageNumber INT = 1,
    @PageSize INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        pr.ReviewId,
        pr.Rating,
        pr.Title,
        pr.ReviewText,
        pr.HelpfulCount,
        pr.CreatedAt,
        u.FullName,
        u.ProfileImgPath,
        pr.IsVerified
    FROM ProductReviews pr
    INNER JOIN Users u ON pr.UserId = u.UserId
    WHERE pr.ProductId = @ProductId AND pr.IsApproved = 1
    ORDER BY pr.CreatedAt DESC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
    
    -- Return total count for pagination
    SELECT COUNT(*) AS TotalReviews
    FROM ProductReviews
    WHERE ProductId = @ProductId AND IsApproved = 1;
END;
GO