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