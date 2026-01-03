using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class Cart
{
    public int CartId { get; set; }

    public int UserId { get; set; }

    public string ProductId { get; set; } = null!;

    public int Quantity { get; set; }

    public decimal UnitPrice { get; set; }

    public DateTime? AddedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Product Product { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
