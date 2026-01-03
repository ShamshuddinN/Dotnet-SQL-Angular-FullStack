using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class VwCategoryProduct
{
    public int CategoryId { get; set; }

    public string CategoryName { get; set; } = null!;

    public string? Description { get; set; }

    public int? ParentCategoryId { get; set; }

    public string? ImageUrl { get; set; }

    public bool? IsActive { get; set; }

    public int? SortOrder { get; set; }

    public string? ProductId { get; set; }

    public string? ProductName { get; set; }

    public decimal? Price { get; set; }

    public decimal? ComparePrice { get; set; }

    public decimal? DiscountedPrice { get; set; }

    public string? ProductImage { get; set; }

    public bool? IsFeatured { get; set; }

    public decimal? AverageRating { get; set; }

    public int QuantityAvailable { get; set; }

    public string StockStatus { get; set; } = null!;

    public int? ProductCount { get; set; }
}
