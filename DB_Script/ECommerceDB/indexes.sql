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
