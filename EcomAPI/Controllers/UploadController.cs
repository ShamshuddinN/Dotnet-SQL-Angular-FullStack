using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using System.Net.Http.Headers;

namespace EcomAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class UploadController : ControllerBase
{
    private readonly IWebHostEnvironment _environment;

    public UploadController(IWebHostEnvironment environment)
    {
        _environment = environment;
    }

    [HttpPost("product-image")]
    //[Authorize(Roles = "Admin, Vendor, Moderator")]
    [SwaggerOperation(Summary = "Upload product image", Description = "Uploads an image file and returns the relative URL.")]
    [SwaggerResponse(200, "Image uploaded successfully", typeof(object))]
    [SwaggerResponse(400, "Invalid file")]
    public async Task<IActionResult> UploadProductImage(IFormFile file)
    {
        if (file == null || file.Length == 0)
            return BadRequest(new { Message = "No file uploaded." });

        var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".webp" };
        var extension = Path.GetExtension(file.FileName).ToLowerInvariant();

        if (!allowedExtensions.Contains(extension))
            return BadRequest(new { Message = "Invalid file type. Allowed: jpg, jpeg, png, webp." });

        if (file.Length > 5 * 1024 * 1024) // 5MB limit
            return BadRequest(new { Message = "File size exceeds 5MB limit." });

        // Ensure directory exists
        var uploadsFolder = Path.Combine(_environment.WebRootPath ?? Path.Combine(Directory.GetCurrentDirectory(), "wwwroot"), "images", "products");
        if (!Directory.Exists(uploadsFolder))
            Directory.CreateDirectory(uploadsFolder);

        var fileName = $"{Guid.NewGuid()}{extension}";
        var filePath = Path.Combine(uploadsFolder, fileName);

        using (var stream = new FileStream(filePath, FileMode.Create))
        {
            await file.CopyToAsync(stream);
        }

        var url = $"/images/products/{fileName}";
        // E.g. https://localhost:7153/images/products/guid.jpg
        // Frontend should prepend base URL if needed, or we return full URL if we have HttpContext reference.
        // Relative is often safer for portability.
        
        return Ok(new { Url = url });
    }
}
