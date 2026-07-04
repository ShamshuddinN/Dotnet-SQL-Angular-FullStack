CREATE TABLE ProductCategories (
    CategoryId INT IDENTITY(1, 1) NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    ParentCategoryId INT NOT NULL, -- Changed to NOT NULL as requested
    IsActive BIT NOT NULL DEFAULT 1,
    DisplayOrder INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0
);

ALTER TABLE ProductCategories
ADD CONSTRAINT PK_ProductCategories PRIMARY KEY (CategoryId);

ALTER TABLE ProductCategories
ADD CONSTRAINT UQ_ProductCategories_CategoryName UNIQUE (CategoryName); -- Added UNIQUE constraint as requested

ALTER TABLE "ProductCategories"
ADD CONSTRAINT FK_ProductCategories_ParentCategory
FOREIGN KEY (ParentCategoryId) REFERENCES ProductCategories(CategoryId); --* Removed on delete cascade

CREATE INDEX IX_ProductCategories_IsActive ON ProductCategories(IsActive);
CREATE INDEX IX_ProductCategories_ParentCategoryId ON ProductCategories(ParentCategoryId);


CREATE TABLE OrderStatuses (
    StatusId INT IDENTITY(1, 1) NOT NULL,
    StatusName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0, -- Added IsDeleted column
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

ALTER TABLE OrderStatuses
ADD CONSTRAINT PK_OrderStatuses PRIMARY KEY (StatusId);

-- Added CHECK constraint for specific status values as requested
ALTER TABLE OrderStatuses
ADD CONSTRAINT CK_OrderStatuses_StatusName
CHECK (StatusName IN ('Delivered', 'Pending', 'Placed', 'Dispatched', 'Shipped', 'Unknown', 'Lost'));

CREATE UNIQUE INDEX UIX_OrderStatuses_StatusName ON OrderStatuses(StatusName)
WHERE IsDeleted = 0 AND IsActive = 1;


CREATE TABLE PaymentMethods (
    MethodId INT IDENTITY(1, 1) NOT NULL,
    MethodName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0, -- Added IsDeleted column
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE() -- Added UpdatedAt column as requested
);

ALTER TABLE PaymentMethods
ADD CONSTRAINT PK_PaymentMethods PRIMARY KEY (MethodId);

CREATE UNIQUE INDEX UIX_PaymentMethods_MethodName ON PaymentMethods(MethodName)
WHERE IsDeleted = 0 AND IsActive = 1;


-- NEW: AddressType lookup table as requested
CREATE TABLE AddressTypes (
    AddressTypeId INT IDENTITY(1, 1) NOT NULL,
    TypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0, -- Added IsDeleted column
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

ALTER TABLE AddressTypes
ADD CONSTRAINT PK_AddressTypes PRIMARY KEY (AddressTypeId);

CREATE UNIQUE INDEX UIX_AddressTypes_TypeName ON AddressTypes(TypeName)
WHERE IsDeleted = 0 AND IsActive = 1;


-- =============================================
-- CORE ENTITY TABLES
-- =============================================

CREATE TABLE Roles (
    RoleId INT IDENTITY(1, 1) NOT NULL,
    RoleName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

ALTER TABLE Roles
ADD CONSTRAINT PK_Roles PRIMARY KEY (RoleId);

CREATE UNIQUE INDEX UIX_Roles_RoleName ON Roles(RoleName)
WHERE IsDeleted = 0 AND IsActive = 1;


-- REVISED: Users table (formerly Customers) based on user feedback
-- Email: unique but allows NULLs
-- FirstName/LastName: required instead of FullName
CREATE TABLE Users (
    UserId INT IDENTITY(1000, 1) NOT NULL,
    Username NVARCHAR(100) NOT NULL, -- Added Username column as requested
    Email NVARCHAR(255) NULL, -- Unique but allows NULLs per user request
    PasswordHash NVARCHAR(255) NOT NULL,
    FirstName NVARCHAR(100) NOT NULL, -- Required per user request
    LastName NVARCHAR(100) NOT NULL,  -- Required per user request
    ProfileImgPath NVARCHAR(500) NULL,
    Gender CHAR(1) NULL,
    DateOfBirth DATE NULL,
    RoleId INT NOT NULL,
    PhoneNumber NVARCHAR(20) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    EmailVerified BIT NOT NULL DEFAULT 0,
    EmailVerificationToken NVARCHAR(500) NULL,
    EmailVerifiedAt DATETIME2 NULL,
    PasswordResetToken NVARCHAR(500) NULL,
    PasswordResetExpiresAt DATETIME2 NULL,
    LastLoginAt DATETIME2 NULL,
    TwoFactorEnabled BIT NOT NULL DEFAULT 0,
    AccessFailedCount INT NOT NULL DEFAULT 0,
    LockoutEnd DATETIME2 NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (UserId);

ALTER TABLE Users
ADD CONSTRAINT FK_Users_Roles
FOREIGN KEY (RoleId) REFERENCES Roles(RoleId);

-- Unique index on Email that allows multiple NULLs
CREATE UNIQUE INDEX UIX_Users_Email ON Users(Email)
WHERE Email IS NOT NULL AND IsDeleted = 0;
CREATE INDEX IX_Users_RoleId ON Users(RoleId);
CREATE INDEX IX_Users_IsActive ON Users(IsActive);


CREATE TABLE Addresses (
    AddressId INT IDENTITY(1, 1) NOT NULL,
    UserId INT NOT NULL,
    AddressLine1 NVARCHAR(255) NOT NULL,
    AddressLine2 NVARCHAR(255) NULL,
    City NVARCHAR(100) NOT NULL,
    StateProvince NVARCHAR(100) NOT NULL, -- Renamed from State to StateProvince for clarity
    PostalCode NVARCHAR(20) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    AddressTypeId INT NOT NULL, -- FK to AddressTypes lookup table instead of free text
    IsDefault BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE Addresses
ADD CONSTRAINT PK_Addresses PRIMARY KEY (AddressId);

ALTER TABLE Addresses
ADD CONSTRAINT FK_Addresses_Users
FOREIGN KEY (UserId) REFERENCES Users(UserId);

ALTER TABLE Addresses
ADD CONSTRAINT FK_Addresses_AddressType
FOREIGN KEY (AddressTypeId) REFERENCES AddressTypes(AddressTypeId);

CREATE INDEX IX_Addresses_UserId ON Addresses(UserId);
CREATE INDEX IX_Addresses_IsDefault ON Addresses(UserId, IsDefault)
WHERE IsDefault = 1 AND IsActive = 1;
CREATE INDEX IX_Addresses_IsActive ON Addresses(IsActive);
CREATE INDEX IX_Addresses_AddressTypeId ON Addresses(AddressTypeId);


-- =============================================
-- PRODUCT CATALOG TABLES
-- =============================================

CREATE TABLE Products (
    ProductId INT IDENTITY(1, 1) NOT NULL,
    CategoryId INT NOT NULL,
    SKU NVARCHAR(100) NOT NULL,
    ProductName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    ShortDescription NVARCHAR(500) NULL,
    Price DECIMAL(18, 2) NOT NULL,
    CompareAtPrice DECIMAL(18, 2) NULL,
    CostPrice DECIMAL(18, 2) NULL,
    Weight DECIMAL(8, 3) NULL, -- in kg
    Length DECIMAL(8, 3) NULL, -- in cm
    Width DECIMAL(8, 3) NULL, -- in cm
    Height DECIMAL(8, 3) NULL, -- in cm
    IsActive BIT NOT NULL DEFAULT 1,
    IsFeatured BIT NOT NULL DEFAULT 0,
    IsDigital BIT NOT NULL DEFAULT 0,
    TrackInventory BIT NOT NULL DEFAULT 1,
    StockQuantity INT NOT NULL DEFAULT 0,
    ReorderLevel INT NULL,
    MetaTitle NVARCHAR(255) NULL,
    MetaDescription NVARCHAR(500) NULL,
    MetaKeywords NVARCHAR(500) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE Products
ADD CONSTRAINT PK_Products PRIMARY KEY (ProductId);

ALTER TABLE Products
ADD CONSTRAINT FK_Products_Category
FOREIGN KEY (CategoryId) REFERENCES ProductCategories(CategoryId);

CREATE UNIQUE INDEX UIX_Products_SKU ON Products(SKU)
WHERE IsDeleted = 0;
CREATE INDEX IX_Products_CategoryId ON Products(CategoryId);
CREATE INDEX IX_Products_IsActive ON Products(IsActive);
CREATE INDEX IX_Products_IsFeatured ON Products(IsFeatured)
WHERE IsActive = 1 AND IsFeatured = 1;
CREATE INDEX IX_Products_Price ON Products(Price)
WHERE IsActive = 1;


CREATE TABLE ProductImages (
    ImageId INT IDENTITY(1, 1) NOT NULL,
    ProductId INT NOT NULL,
    ImageUrl NVARCHAR(500) NOT NULL,
    AltText NVARCHAR(255) NULL,
    IsPrimary BIT NOT NULL DEFAULT 0,
    DisplayOrder INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(), -- Added UpdatedAt column as requested
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE ProductImages
ADD CONSTRAINT PK_ProductImages PRIMARY KEY (ImageId);

ALTER TABLE ProductImages
ADD CONSTRAINT FK_ProductImages_Product
FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE;

CREATE INDEX IX_ProductImages_ProductId ON ProductImages(ProductId);
CREATE INDEX IX_ProductImages_IsPrimary ON ProductImages(ProductId, IsPrimary)
WHERE IsPrimary = 1;


CREATE TABLE Inventory (
    InventoryId INT IDENTITY(1, 1) NOT NULL,
    ProductId INT NOT NULL,
    LocationId NVARCHAR(100) NULL DEFAULT 'MainWarehouse',
    QuantityAvailable INT NOT NULL DEFAULT 0,
    QuantityReserved INT NOT NULL DEFAULT 0, -- Tracks reserved inventory as requested
    LastRestockedAt DATETIME2 NULL,
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE Inventory
ADD CONSTRAINT PK_Inventory PRIMARY KEY (InventoryId);

ALTER TABLE Inventory
ADD CONSTRAINT FK_Inventory_Product
FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE;

CREATE UNIQUE INDEX UIX_Inventory_Product_Location ON Inventory(ProductId, LocationId);


-- =============================================
-- SHOPPING CART TABLES
-- =============================================

CREATE TABLE ShoppingCarts (
    CartId INT IDENTITY(1, 1) NOT NULL,
    UserId INT NULL,
    SessionId NVARCHAR(255) NULL, -- for anonymous users
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    ExpiresAt DATETIME2 NOT NULL DEFAULT DATEADD(DAY, 7, GETUTCDATE()),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE ShoppingCarts
ADD CONSTRAINT PK_ShoppingCarts PRIMARY KEY (CartId);

ALTER TABLE ShoppingCarts
ADD CONSTRAINT FK_ShoppingCarts_User
FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE SET NULL;

CREATE UNIQUE INDEX UIX_ShoppingCarts_UserId_Active 
ON ShoppingCarts(UserId)
WHERE UserId IS NOT NULL AND IsDeleted = 0; --* Updated

--* 1. Fixed the filtered index to use the static IsDeleted column
CREATE UNIQUE INDEX UIX_ShoppingCarts_SessionId ON ShoppingCarts(SessionId)
WHERE SessionId IS NOT NULL AND IsDeleted = 0;

--* 2. This standard index is fully valid and will execute without errors
CREATE INDEX IX_ShoppingCarts_ExpiresAt ON ShoppingCarts(ExpiresAt);


CREATE TABLE CartItems (
    CartItemId INT IDENTITY(1, 1) NOT NULL,
    CartId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(18, 2) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE CartItems
ADD CONSTRAINT PK_CartItems PRIMARY KEY (CartItemId);

ALTER TABLE CartItems
ADD CONSTRAINT FK_CartItems_Cart
FOREIGN KEY (CartId) REFERENCES ShoppingCarts(CartId) ON DELETE CASCADE;

ALTER TABLE CartItems
ADD CONSTRAINT FK_CartItems_Product
FOREIGN KEY (ProductId) REFERENCES Products(ProductId);

CREATE UNIQUE INDEX UIX_CartItems_Cart_Product ON CartItems(CartId, ProductId);
CREATE INDEX IX_CartItems_ProductId ON CartItems(ProductId);


-- =============================================
-- ORDER MANAGEMENT TABLES
-- =============================================

CREATE TABLE Orders (
    OrderId INT IDENTITY(1, 1) NOT NULL,
    OrderNumber NVARCHAR(50) NOT NULL,
    UserId INT NOT NULL,
    BillingAddressId INT NOT NULL,
    ShippingAddressId INT NOT NULL,
    StatusId INT NOT NULL DEFAULT 1, -- Pending
    PaymentMethodId INT NULL,
    Subtotal DECIMAL(18, 2) NOT NULL,
    TaxAmount DECIMAL(18, 2) NOT NULL DEFAULT 0,
    ShippingAmount DECIMAL(18, 2) NOT NULL DEFAULT 0,
    DiscountAmount DECIMAL(18, 2) NOT NULL DEFAULT 0,
    TotalAmount DECIMAL(18, 2) NOT NULL,
    CurrencyCode CHAR(3) NOT NULL DEFAULT 'USD',
    PaymentStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending', -- Payment status: Pending, Processing, Completed, Failed, Refunded, PartiallyRefunded
    TrackingNumber NVARCHAR(100) NULL,
    Notes NVARCHAR(MAX) NULL,
    ErrorMessage NVARCHAR(MAX) NULL, -- Added ErrorMessage column as requested
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CompletedAt DATETIME2 NULL,
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE Orders
ADD CONSTRAINT PK_Orders PRIMARY KEY (OrderId);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_User
FOREIGN KEY (UserId) REFERENCES Users(UserId);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_BillingAddress
FOREIGN KEY (BillingAddressId) REFERENCES Addresses(AddressId);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_ShippingAddress
FOREIGN KEY (ShippingAddressId) REFERENCES Addresses(AddressId);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_OrderStatus
FOREIGN KEY (StatusId) REFERENCES OrderStatuses(StatusId);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_PaymentMethod
FOREIGN KEY (PaymentMethodId) REFERENCES PaymentMethods(MethodId);

CREATE UNIQUE INDEX UIX_Orders_OrderNumber ON Orders(OrderNumber)
WHERE IsDeleted = 0;
CREATE INDEX IX_Orders_UserId ON Orders(UserId);
CREATE INDEX IX_Orders_StatusId ON Orders(StatusId);
CREATE INDEX IX_Orders_CreatedAt ON Orders(CreatedAt);
CREATE INDEX IX_Orders_PaymentStatus ON Orders(PaymentStatus);
CREATE INDEX IX_Orders_CompletedAt ON Orders(CompletedAt)
WHERE CompletedAt IS NOT NULL;


CREATE TABLE OrderItems (
    OrderItemId INT IDENTITY(1, 1) NOT NULL,
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    ProductNameSnapshot NVARCHAR(255) NOT NULL,
    SKUSnapshot NVARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(18, 2) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    TotalPrice DECIMAL(18, 2) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE OrderItems
ADD CONSTRAINT PK_OrderItems PRIMARY KEY (OrderItemId);

ALTER TABLE OrderItems
ADD CONSTRAINT FK_OrderItems_Order
FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON DELETE CASCADE;

ALTER TABLE OrderItems
ADD CONSTRAINT FK_OrderItems_Product
FOREIGN KEY (ProductId) REFERENCES Products(ProductId);

CREATE INDEX IX_OrderItems_OrderId ON OrderItems(OrderId);
CREATE INDEX IX_OrderItems_ProductId ON OrderItems(ProductId);


-- NEW: PaymentStatus lookup table as requested
CREATE TABLE PaymentStatuses (
    StatusId INT IDENTITY(1, 1) NOT NULL,
    StatusName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0, -- Added IsDeleted column
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

ALTER TABLE PaymentStatuses
ADD CONSTRAINT PK_PaymentStatuses PRIMARY KEY (StatusId);

-- Added CHECK constraint for payment status values
ALTER TABLE PaymentStatuses
ADD CONSTRAINT CK_PaymentStatuses_StatusName
CHECK (StatusName IN ('Pending', 'Processing', 'Completed', 'Failed', 'Refunded', 'PartiallyRefunded'));

CREATE UNIQUE INDEX UIX_PaymentStatuses_StatusName ON PaymentStatuses(StatusName)
WHERE IsDeleted = 0 AND IsActive = 1;


CREATE TABLE Payments (
    PaymentId INT IDENTITY(1, 1) NOT NULL,
    OrderId INT NOT NULL,
    PaymentMethodId INT NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL,
    CurrencyCode CHAR(3) NOT NULL DEFAULT 'INR',
    TransactionId NVARCHAR(255) NULL,
    PaymentStatusId INT NOT NULL, -- Changed to FK to PaymentStatuses lookup table as requested
    GatewayResponse NVARCHAR(MAX) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE Payments
ADD CONSTRAINT PK_Payments PRIMARY KEY (PaymentId);

ALTER TABLE Payments
ADD CONSTRAINT FK_Payments_Order
FOREIGN KEY (OrderId) REFERENCES Orders(OrderId);

ALTER TABLE Payments
ADD CONSTRAINT FK_Payments_PaymentMethod
FOREIGN KEY (PaymentMethodId) REFERENCES PaymentMethods(MethodId);

ALTER TABLE Payments
ADD CONSTRAINT FK_Payments_PaymentStatus
FOREIGN KEY (PaymentStatusId) REFERENCES PaymentStatuses(StatusId);

CREATE INDEX IX_Payments_OrderId ON Payments(OrderId);
CREATE INDEX IX_Payments_PaymentStatus ON Payments(PaymentStatusId);
CREATE INDEX IX_Payments_CreatedAt ON Payments(CreatedAt);


CREATE TABLE OrderStatusHistory (
    HistoryId INT IDENTITY(1, 1) NOT NULL,
    OrderId INT NOT NULL,
    StatusId INT NOT NULL,
    ChangedByUserId INT NULL, -- Admin/user who changed status
    Notes NVARCHAR(MAX) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE OrderStatusHistory
ADD CONSTRAINT PK_OrderStatusHistory PRIMARY KEY (HistoryId);

ALTER TABLE OrderStatusHistory
ADD CONSTRAINT FK_OrderStatusHistory_Order
FOREIGN KEY (OrderId) REFERENCES Orders(OrderId);

ALTER TABLE OrderStatusHistory
ADD CONSTRAINT FK_OrderStatusHistory_OrderStatus
FOREIGN KEY (StatusId) REFERENCES OrderStatuses(StatusId);

ALTER TABLE OrderStatusHistory
ADD CONSTRAINT FK_OrderStatusHistory_User
FOREIGN KEY (ChangedByUserId) REFERENCES Users(UserId);

CREATE INDEX IX_OrderStatusHistory_OrderId ON OrderStatusHistory(OrderId);
CREATE INDEX IX_OrderStatusHistory_CreatedAt ON OrderStatusHistory(CreatedAt);


-- =============================================
-- USER ENGAGEMENT TABLES
-- =============================================

-- REVISED: Reviews table based on user feedback
-- Added: Likes, Dislikes (separate counts), IsVerifiedPurchase flag
CREATE TABLE Reviews (
    ReviewId INT IDENTITY(1, 1) NOT NULL,
    ProductId INT NOT NULL,
    UserId INT NOT NULL,
    Rating DECIMAL(3, 2) NOT NULL CHECK (Rating >= 1.0 AND Rating <= 5.0), -- Changed to decimal as requested to store values like 4.3, 4.4, 4.8
    Title NVARCHAR(255) NULL,
    Comment NVARCHAR(MAX) NULL,
    IsApproved BIT NOT NULL DEFAULT 0,
    Likes INT NOT NULL DEFAULT 0, -- Separate likes count as requested
    Dislikes INT NOT NULL DEFAULT 0, -- Separate dislikes count as requested
    IsVerifiedPurchase BIT NOT NULL DEFAULT 0, -- Verified purchase flag as requested
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE Reviews
ADD CONSTRAINT PK_Reviews PRIMARY KEY (ReviewId);

ALTER TABLE Reviews
ADD CONSTRAINT FK_Reviews_Product
FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE;

ALTER TABLE Reviews
ADD CONSTRAINT FK_Reviews_User
FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE;

CREATE UNIQUE INDEX UIX_Reviews_Product_User ON Reviews(ProductId, UserId);
CREATE INDEX IX_Reviews_ProductId ON Reviews(ProductId);
CREATE INDEX IX_Reviews_IsApproved ON Reviews(IsApproved);
CREATE INDEX IX_Reviews_CreatedAt ON Reviews(CreatedAt);
CREATE INDEX IX_Reviews_IsVerifiedPurchase ON Reviews(IsVerifiedPurchase);


CREATE TABLE Wishlists (
    WishlistId INT IDENTITY(1, 1) NOT NULL,
    UserId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL DEFAULT 'My Wishlist',
    IsPublic BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE Wishlists
ADD CONSTRAINT PK_Wishlists PRIMARY KEY (WishlistId);

ALTER TABLE Wishlists
ADD CONSTRAINT FK_Wishlists_User
FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE;

CREATE UNIQUE INDEX UIX_Wishlists_User_Default ON Wishlists(UserId)
WHERE Name = 'My Wishlist';


CREATE TABLE WishlistItems (
    WishlistItemId INT IDENTITY(1, 1) NOT NULL,
    WishlistId INT NOT NULL,
    ProductId INT NOT NULL,
    AddedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE WishlistItems
ADD CONSTRAINT PK_WishlistItems PRIMARY KEY (WishlistItemId);

ALTER TABLE WishlistItems
ADD CONSTRAINT FK_WishlistItems_Wishlist
FOREIGN KEY (WishlistId) REFERENCES Wishlists(WishlistId) ON DELETE CASCADE;

ALTER TABLE WishlistItems
ADD CONSTRAINT FK_WishlistItems_Product
FOREIGN KEY (ProductId) REFERENCES Products(ProductId);

CREATE UNIQUE INDEX UIX_WishlistItems_Wishlist_Product ON WishlistItems(WishlistId, ProductId);
CREATE INDEX IX_WishlistItems_ProductId ON WishlistItems(ProductId);


-- =============================================
-- AUDIT / SYSTEM TABLES (Optional)
-- =============================================

CREATE TABLE ApiLogs (
    LogId BIGINT IDENTITY(1, 1) NOT NULL,
    UserId INT NULL,
    Endpoint NVARCHAR(500) NOT NULL,
    HttpMethod NVARCHAR(10) NOT NULL,
    RequestPayload NVARCHAR(MAX) NULL,
    ResponseStatusCode INT NULL,
    ResponsePayload NVARCHAR(MAX) NULL,
    ErrorMessage NVARCHAR(MAX) NULL,
    IpAddress NVARCHAR(50) NULL, -- For session tracking as requested (consider GDPR compliance in application layer)
    UserAgent NVARCHAR(500) NULL, -- For session tracking as requested (consider GDPR compliance in application layer)
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column
);

ALTER TABLE ApiLogs
ADD CONSTRAINT PK_ApiLogs PRIMARY KEY (LogId);

ALTER TABLE ApiLogs
ADD CONSTRAINT FK_ApiLogs_User
FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE SET NULL;

CREATE INDEX IX_ApiLogs_UserId ON ApiLogs(UserId);
CREATE INDEX IX_ApiLogs_Endpoint ON ApiLogs(Endpoint);
CREATE INDEX IX_ApiLogs_CreatedAt ON ApiLogs(CreatedAt);
--* removed

-- =============================================
-- ERROR LOGGING TABLE
-- =============================================

CREATE TABLE ErrorLog (
    ErrorLogId INT IDENTITY(1,1) PRIMARY KEY,
    ErrorTime DATETIME DEFAULT GETDATE(),
    ErrorMessage NVARCHAR(4000) NOT NULL,
    ErrorSeverity INT NOT NULL,
    ErrorState INT NOT NULL,
    ErrorProcedure NVARCHAR(128) NULL,
    ErrorLine INT NULL,
    UserName NVARCHAR(128) DEFAULT SUSER_SNAME(),
    HostName NVARCHAR(128) DEFAULT HOST_NAME(),
    IsDeleted BIT NOT NULL DEFAULT 0 -- Added IsDeleted column for consistency
);

-- Index for error log queries
CREATE INDEX IX_ErrorLog_ErrorTime ON ErrorLog(ErrorTime);
CREATE INDEX IX_ErrorLog_ErrorProcedure ON ErrorLog(ErrorProcedure);