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
}
