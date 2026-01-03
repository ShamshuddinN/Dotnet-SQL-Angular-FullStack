USE [master]
GO

--If unable to drop database, uncomment the following lines to set the database to SINGLE_USER mode first
--ALTER DATABASE [ECommerceDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--GO
IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE ('[' + name + ']' = N'ECommerceDB' OR name = N'ECommerceDB')))
DROP DATABASE ECommerceDB


CREATE DATABASE ECommerceDB;
GO

USE ECommerceDB;
GO

-- Drop triggers first (before tables since triggers are attached to tables)
DROP TRIGGER IF EXISTS trg_UpdateUserTimestamp;
DROP TRIGGER IF EXISTS trg_UpdateProductTimestamp;
DROP TRIGGER IF EXISTS trg_UpdateCategoryTimestamp;
DROP TRIGGER IF EXISTS trg_UpdateInventoryOnOrder;
DROP TRIGGER IF EXISTS trg_UpdateInventoryOnOrderStatus;
DROP TRIGGER IF EXISTS trg_UpdateProductRating;
DROP TRIGGER IF EXISTS trg_ValidateCartQuantity;
DROP TRIGGER IF EXISTS trg_MaintainDefaultAddress;
DROP TRIGGER IF EXISTS trg_MaintainDefaultPaymentMethod;
GO

-- Drop all tables in correct order to avoid foreign key conflicts
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS OrderReviews;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Cart;
DROP TABLE IF EXISTS ProductReviews;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Roles;
DROP TABLE IF EXISTS PaymentMethods;
DROP TABLE IF EXISTS Addresses;
DROP TABLE IF EXISTS WishList;
GO

-- Drop other objects
DROP FUNCTION IF EXISTS dbo.fn_GetProductAverageRating;
DROP FUNCTION IF EXISTS dbo.fn_GetUserTotalOrders;
DROP FUNCTION IF EXISTS dbo.fn_GetUserTotalSpent;
DROP FUNCTION IF EXISTS dbo.fn_GetProductStockStatus;
DROP FUNCTION IF EXISTS dbo.fn_CalculateOrderTotal;
DROP FUNCTION IF EXISTS dbo.fn_GetCartTotal;
DROP FUNCTION IF EXISTS dbo.fn_GetCategoryProductCount;
DROP FUNCTION IF EXISTS dbo.fn_GetDiscountedPrice;
DROP PROCEDURE IF EXISTS usp_RegisterUser;
DROP PROCEDURE IF EXISTS usp_InsertProduct;
DROP PROCEDURE IF EXISTS usp_CreateOrder;
DROP PROCEDURE IF EXISTS usp_AddToCart;
DROP PROCEDURE IF EXISTS usp_UpdateInventory;
DROP PROCEDURE IF EXISTS usp_GetUserCart;
DROP PROCEDURE IF EXISTS usp_RemoveFromCart;
DROP PROCEDURE IF EXISTS usp_ClearCart;
DROP PROCEDURE IF EXISTS usp_AddProductReview;
DROP PROCEDURE IF EXISTS usp_GetProductReviews;
DROP VIEW IF EXISTS vw_ProductDetails;
DROP VIEW IF EXISTS vw_UserOrderHistory;
DROP VIEW IF EXISTS vw_OrderDetails;
DROP VIEW IF EXISTS vw_CategoryProducts;
DROP VIEW IF EXISTS vw_UserDashboard;
DROP VIEW IF EXISTS vw_SalesReport;
GO
