using System.ComponentModel.DataAnnotations;

namespace EcomAPI.DTOs;

public class ProductCreateDto
{
    [Required]
    [StringLength(20)]
    public string ProductId { get; set; } = null!;

    [Required]
    [StringLength(255)]
    public string ProductName { get; set; } = null!;

    public string? Description { get; set; }

    [StringLength(500)]
    public string? ShortDescription { get; set; }

    [Required]
    [StringLength(50)]
    public string Sku { get; set; } = null!;

    [Required]
    [Range(0.01, double.MaxValue)]
    public decimal Price { get; set; }

    public decimal? ComparePrice { get; set; }

    public decimal? CostPrice { get; set; }

    [Required]
    public int CategoryId { get; set; }

    [StringLength(100)]
    public string? Brand { get; set; }

    public decimal? Weight { get; set; }

    [StringLength(50)]
    public string? Dimensions { get; set; }

    [StringLength(50)]
    public string? Color { get; set; }

    [StringLength(50)]
    public string? Size { get; set; }

    [StringLength(255)]
    public string? ImageUrl { get; set; }

    // Inventory settings
    public int InitialQuantity { get; set; } = 0;
    public int ReorderLevel { get; set; } = 10;
    public int ReorderQuantity { get; set; } = 50;
}
