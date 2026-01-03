using EcomDAL.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace EcomDAL.Repositories;

public class ProductRepository : IProductRepository
{
    private readonly EcommerceDbContext _context;

    public ProductRepository(EcommerceDbContext context)
    {
        _context = context;
    }

    public int InsertProduct(Product product, int initialQuantity, int reorderLevel, int reorderQuantity)
    {
        var productIdParam = new SqlParameter("@ProductId", product.ProductId);
        var productNameParam = new SqlParameter("@ProductName", product.ProductName);
        var descriptionParam = new SqlParameter("@Description", product.Description ?? (object)DBNull.Value);
        var shortDescriptionParam = new SqlParameter("@ShortDescription", product.ShortDescription ?? (object)DBNull.Value);
        var skuParam = new SqlParameter("@SKU", product.Sku);
        var priceParam = new SqlParameter("@Price", product.Price);
        var comparePriceParam = new SqlParameter("@ComparePrice", product.ComparePrice ?? (object)DBNull.Value);
        var costPriceParam = new SqlParameter("@CostPrice", product.CostPrice ?? (object)DBNull.Value);
        var categoryIdParam = new SqlParameter("@CategoryId", product.CategoryId);
        var brandParam = new SqlParameter("@Brand", product.Brand ?? (object)DBNull.Value);
        var weightParam = new SqlParameter("@Weight", product.Weight ?? (object)DBNull.Value);
        var dimensionsParam = new SqlParameter("@Dimensions", product.Dimensions ?? (object)DBNull.Value);
        var colorParam = new SqlParameter("@Color", product.Color ?? (object)DBNull.Value);
        var sizeParam = new SqlParameter("@Size", product.Size ?? (object)DBNull.Value);
        var imageUrlParam = new SqlParameter("@ImageUrl", product.ImageUrl ?? (object)DBNull.Value);
        
        var initialQuantityParam = new SqlParameter("@InitialQuantity", initialQuantity);
        var reorderLevelParam = new SqlParameter("@ReorderLevel", reorderLevel);
        var reorderQuantityParam = new SqlParameter("@ReorderQuantity", reorderQuantity);

        var result = _context.Database
            .SqlQueryRaw<int>(
                "EXEC usp_InsertProduct @ProductId, @ProductName, @Description, @ShortDescription, @SKU, @Price, @ComparePrice, @CostPrice, @CategoryId, @Brand, @Weight, @Dimensions, @Color, @Size, @ImageUrl, @InitialQuantity, @ReorderLevel, @ReorderQuantity",
                productIdParam, productNameParam, descriptionParam, shortDescriptionParam, skuParam, priceParam, 
                comparePriceParam, costPriceParam, categoryIdParam, brandParam, weightParam, dimensionsParam, 
                colorParam, sizeParam, imageUrlParam, initialQuantityParam, reorderLevelParam, reorderQuantityParam
            )
            .AsEnumerable()
            .FirstOrDefault();

        return result;
    }
}
