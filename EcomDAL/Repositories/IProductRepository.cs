using EcomDAL.Models;

namespace EcomDAL.Repositories;

public interface IProductRepository
{
    int InsertProduct(Product product, int initialQuantity, int reorderLevel, int reorderQuantity);
    int UpdateProduct(Product product, int? reorderLevel, int? reorderQuantity);
    int DeleteProduct(string productId);
    Product? GetProductById(string productId);
    IEnumerable<Product> GetAllProducts();
    IEnumerable<Category> GetAllCategories();
}
