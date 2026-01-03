using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class ProductReview
{
    public int ReviewId { get; set; }

    public string ProductId { get; set; } = null!;

    public int UserId { get; set; }

    public int Rating { get; set; }

    public string? Title { get; set; }

    public string ReviewText { get; set; } = null!;

    public bool? IsVerified { get; set; }

    public bool? IsApproved { get; set; }

    public int? HelpfulCount { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Product Product { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
