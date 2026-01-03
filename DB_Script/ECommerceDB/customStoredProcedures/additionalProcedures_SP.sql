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