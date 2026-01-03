using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class VwUserDashboard
{
    public int UserId { get; set; }

    public string FullName { get; set; } = null!;

    public string Email { get; set; } = null!;

    public DateTime? CreatedAt { get; set; }

    public int TotalOrders { get; set; }

    public decimal TotalSpent { get; set; }

    public int CartItems { get; set; }

    public int WishListItems { get; set; }

    public int ReviewCount { get; set; }

    public DateTime? LastOrderDate { get; set; }
}
