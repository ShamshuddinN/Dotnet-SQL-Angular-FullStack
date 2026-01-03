using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class WishList
{
    public int WishListId { get; set; }

    public int UserId { get; set; }

    public string ProductId { get; set; } = null!;

    public DateTime? AddedAt { get; set; }

    public virtual Product Product { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
