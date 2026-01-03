using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class VwSalesReport
{
    public int? OrderYear { get; set; }

    public int? OrderMonth { get; set; }

    public int? OrderDay { get; set; }

    public int? OrderCount { get; set; }

    public decimal? TotalRevenue { get; set; }

    public decimal? AverageOrderValue { get; set; }

    public int? UniqueCustomers { get; set; }

    public int? UniqueProductsSold { get; set; }
}
