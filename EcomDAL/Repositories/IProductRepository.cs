using EcomDAL.Models;

namespace EcomDAL.Repositories;

public interface IProductRepository
{
    int InsertProduct(Product product, int initialQuantity, int reorderLevel, int reorderQuantity);
}
