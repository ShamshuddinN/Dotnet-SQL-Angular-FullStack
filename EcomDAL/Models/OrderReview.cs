using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class OrderReview
{
    public int OrderReviewId { get; set; }

    public int OrderId { get; set; }

    public int UserId { get; set; }

    public int OverallRating { get; set; }

    public int? ServiceRating { get; set; }

    public int? DeliveryRating { get; set; }

    public string? ReviewText { get; set; }

    public bool? IsPublic { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Order Order { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
