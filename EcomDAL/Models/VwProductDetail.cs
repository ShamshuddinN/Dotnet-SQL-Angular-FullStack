using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class VwProductDetail
{
    public string ProductId { get; set; } = null!;

    public string ProductName { get; set; } = null!;

    public string? Description { get; set; }

    public string? ShortDescription { get; set; }

    public string Sku { get; set; } = null!;

    public decimal Price { get; set; }

    public decimal? ComparePrice { get; set; }

    public decimal? DiscountedPrice { get; set; }

    public int CategoryId { get; set; }

    public string CategoryName { get; set; } = null!;

    public string? Brand { get; set; }

    public decimal? Weight { get; set; }

    public string? Dimensions { get; set; }

    public string? Color { get; set; }

    public string? Size { get; set; }

    public string? ImageUrl { get; set; }

    public string? AdditionalImages { get; set; }

    public string? Tags { get; set; }

    public bool? IsActive { get; set; }

    public bool? IsFeatured { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public decimal AverageRating { get; set; }

    public int ReviewCount { get; set; }

    public int QuantityAvailable { get; set; }

    public int QuantityReserved { get; set; }

    public string StockStatus { get; set; } = null!;
}
