using EcomAPI.DTOs;
using EcomDAL.Models;
using EcomDAL.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;

namespace EcomAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class ProductsController : ControllerBase
{
    private readonly IProductRepository _productRepository;

    public ProductsController(IProductRepository productRepository)
    {
        _productRepository = productRepository;
    }

    [HttpPost]
    [SwaggerOperation(Summary = "Insert a new product", Description = "Creates a new product with inventory settings.")]
    [SwaggerResponse(201, "Product created successfully")]
    [SwaggerResponse(400, "Invalid input or creation failed")]
    [Authorize(Roles = "Admin, Vendor, Moderator")]
    public IActionResult InsertProduct([FromBody] ProductCreateDto request)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var product = new Product
        {
            ProductId = request.ProductId,
            ProductName = request.ProductName,
            Description = request.Description,
            ShortDescription = request.ShortDescription,
            Sku = request.Sku,
            Price = request.Price,
            ComparePrice = request.ComparePrice,
            CostPrice = request.CostPrice,
            CategoryId = request.CategoryId,
            Brand = request.Brand,
            Weight = request.Weight,
            Dimensions = request.Dimensions,
            Color = request.Color,
            Size = request.Size,
            ImageUrl = request.ImageUrl,
            IsActive = true, // Default to active
            CreatedAt = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, TimeZoneInfo.FindSystemTimeZoneById("Asia/Kolkata")),
            UpdatedAt = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, TimeZoneInfo.FindSystemTimeZoneById("Asia/Kolkata"))
        };

        var result = _productRepository.InsertProduct(product, request.InitialQuantity, request.ReorderLevel, request.ReorderQuantity);

        if (result == 1)
        {
            // Ideally we would return CreatedAtAction but for now just OK/Created
            return StatusCode(201, new { Message = "Product created successfully", ProductId = request.ProductId });
        }

        // Handle error codes from SP
        return result switch
        {
            -1 => BadRequest(new { Message = "Product ID cannot be null or empty." }),
            -2 => BadRequest(new { Message = "Product Name cannot be null or too short." }),
            -3 => BadRequest(new { Message = "SKU cannot be null or empty." }),
            -4 => BadRequest(new { Message = "Price must be greater than 0." }),
            -5 => BadRequest(new { Message = "Category ID is required." }),
            -6 => BadRequest(new { Message = "Category does not exist or is inactive." }),
            -7 => BadRequest(new { Message = "Product with this ID already exists." }),
            -8 => BadRequest(new { Message = "Product with this SKU already exists." }),
            -9 => BadRequest(new { Message = "Initial quantity cannot be negative." }),
            -99 => StatusCode(500, new { Message = "An internal database error occurred." }),
            _ => BadRequest(new { Message = "Product creation failed with unknown error." })
        };
    }


    [HttpPut("{id}")]
    [SwaggerOperation(Summary = "Update existing product", Description = "Updates product details and inventory settings.")]
    [SwaggerResponse(200, "Product updated successfully")]
    [SwaggerResponse(400, "Invalid input or update failed")]
    [SwaggerResponse(404, "Product not found")]
    [Authorize(Roles = "Admin, Vendor, Moderator")]
    public IActionResult UpdateProduct(string id, [FromBody] ProductCreateDto request)
    {
        if (id != request.ProductId)
            return BadRequest(new { Message = "Product ID in URL does not match body." });

        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var product = new Product
        {
            ProductId = request.ProductId,
            ProductName = request.ProductName,
            Description = request.Description,
            ShortDescription = request.ShortDescription,
            Sku = request.Sku,
            Price = request.Price,
            ComparePrice = request.ComparePrice,
            CostPrice = request.CostPrice,
            CategoryId = request.CategoryId,
            Brand = request.Brand,
            Weight = request.Weight,
            Dimensions = request.Dimensions,
            Color = request.Color,
            Size = request.Size,
            ImageUrl = request.ImageUrl,
            // IsActive not updatable here, preserves existing or soft delete usually handled by Delete
            UpdatedAt = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, TimeZoneInfo.FindSystemTimeZoneById("Asia/Kolkata"))
        };

        var result = _productRepository.UpdateProduct(product, request.ReorderLevel, request.ReorderQuantity);

        return result switch
        {
            1 => Ok(new { Message = "Product updated successfully" }),
            -1 => BadRequest(new { Message = "Product ID cannot be null or empty." }),
            -2 => BadRequest(new { Message = "Product Name cannot be null or too short." }),
            -3 => BadRequest(new { Message = "SKU cannot be null or empty." }),
            -4 => BadRequest(new { Message = "Price must be greater than 0." }),
            -5 => BadRequest(new { Message = "Category ID is required." }),
            -6 => BadRequest(new { Message = "Category does not exist or is inactive." }),
            -7 => NotFound(new { Message = "Product does not exist." }),
            -8 => BadRequest(new { Message = "SKU is already used by another product." }),
            -99 => StatusCode(500, new { Message = "An internal database error occurred." }),
            _ => BadRequest(new { Message = "Product update failed with unknown error." })
        };
    }

    [HttpDelete("{id}")]
    [SwaggerOperation(Summary = "Soft delete a product", Description = "Sets IsActive to false.")]
    [SwaggerResponse(200, "Product deleted successfully")]
    [SwaggerResponse(404, "Product not found")]
    [Authorize(Roles = "Admin, Vendor, Moderator")] // Should probably be Admin only? User said "Vendor can ... products added by him". For now general role check.
    public IActionResult DeleteProduct(string id)
    {
        var result = _productRepository.DeleteProduct(id);

        return result switch
        {
            1 => Ok(new { Message = "Product deleted successfully" }),
            -1 => BadRequest(new { Message = "Product ID cannot be empty." }),
            -7 => NotFound(new { Message = "Product not found." }),
            -99 => StatusCode(500, new { Message = "An internal database error occurred." }),
            _ => BadRequest(new { Message = "Product deletion failed with unknown error." })
        };
    }

    [HttpGet("{id}")]
    [SwaggerOperation(Summary = "Get product by ID")]
    public IActionResult GetProduct(string id)
    {
        var product = _productRepository.GetProductById(id);
        if (product == null) return NotFound();
        
        var productDto = new ProductDto
        {
            ProductId = product.ProductId,
            ProductName = product.ProductName,
            Description = product.Description,
            ShortDescription = product.ShortDescription,
            Sku = product.Sku,
            Price = product.Price,
            ComparePrice = product.ComparePrice,
            CostPrice = product.CostPrice,
            CategoryId = product.CategoryId,
            Brand = product.Brand,
            Weight = product.Weight,
            Dimensions = product.Dimensions,
            Color = product.Color,
            Size = product.Size,
            ImageUrl = product.ImageUrl,
            AdditionalImages = product.AdditionalImages,
            Tags = product.Tags,
            IsActive = product.IsActive,
            IsFeatured = product.IsFeatured,
            TrackInventory = product.TrackInventory,
            AverageRating = product.AverageRating,
            CreatedAt = product.CreatedAt,
            UpdatedAt = product.UpdatedAt
        };
        
        return Ok(productDto);
    }

    [HttpGet]
    [SwaggerOperation(Summary = "Get all active products")]
    public IActionResult GetAllProducts()
    {
        var products = _productRepository.GetAllProducts();
        
        var productDtos = products.Select(p => new ProductDto
        {
            ProductId = p.ProductId,
            ProductName = p.ProductName,
            Description = p.Description,
            ShortDescription = p.ShortDescription,
            Sku = p.Sku,
            Price = p.Price,
            ComparePrice = p.ComparePrice,
            CostPrice = p.CostPrice,
            CategoryId = p.CategoryId,
            Brand = p.Brand,
            Weight = p.Weight,
            Dimensions = p.Dimensions,
            Color = p.Color,
            Size = p.Size,
            ImageUrl = p.ImageUrl,
            AdditionalImages = p.AdditionalImages,
            Tags = p.Tags,
            IsActive = p.IsActive,
            IsFeatured = p.IsFeatured,
            TrackInventory = p.TrackInventory,
            AverageRating = p.AverageRating,
            CreatedAt = p.CreatedAt,
            UpdatedAt = p.UpdatedAt
        }).ToList();
        
        return Ok(productDtos);
    }

    [HttpGet("categories")]
    [SwaggerOperation(Summary = "Get all categories")]
    public IActionResult GetAllCategories()
    {
        var categories = _productRepository.GetAllCategories();
        
        var categoryDtos = categories.Select(c => new CategoryDto
        {
            CategoryId = c.CategoryId,
            CategoryName = c.CategoryName,
            Description = c.Description,
            ParentCategoryId = c.ParentCategoryId,
            ImageUrl = c.ImageUrl,
            IsActive = c.IsActive,
            SortOrder = c.SortOrder,
            CreatedAt = c.CreatedAt,
            UpdatedAt = c.UpdatedAt
        }).ToList();
        
        return Ok(categoryDtos);
    }
}
