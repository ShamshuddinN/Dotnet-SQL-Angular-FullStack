using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class Product
{
    public string ProductId { get; set; } = null!;

    public string ProductName { get; set; } = null!;

    public string? Description { get; set; }

    public string? ShortDescription { get; set; }

    public string Sku { get; set; } = null!;

    public decimal Price { get; set; }

    public decimal? ComparePrice { get; set; }

    public decimal? CostPrice { get; set; }

    public int CategoryId { get; set; }

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

    public bool? TrackInventory { get; set; }

    public decimal AverageRating { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<Cart> Carts { get; set; } = new List<Cart>();

    public virtual Category Category { get; set; } = null!;

    public virtual Inventory? Inventory { get; set; }

    public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();

    public virtual ICollection<ProductReview> ProductReviews { get; set; } = new List<ProductReview>();

    public virtual ICollection<WishList> WishLists { get; set; } = new List<WishList>();
}
