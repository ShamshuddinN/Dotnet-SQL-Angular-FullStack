using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class Inventory
{
    public int InventoryId { get; set; }

    public string ProductId { get; set; } = null!;

    public int QuantityAvailable { get; set; }

    public int QuantityReserved { get; set; }

    public int QuantityOnOrder { get; set; }

    public int ReorderLevel { get; set; }

    public int ReorderQuantity { get; set; }

    public DateTime? LastStockUpdate { get; set; }

    public virtual Product Product { get; set; } = null!;
}
