using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class PaymentMethod
{
    public int PaymentMethodId { get; set; }

    public int UserId { get; set; }

    public string MethodType { get; set; } = null!;

    public string Provider { get; set; } = null!;

    public string AccountNumber { get; set; } = null!;

    public DateOnly? ExpiryDate { get; set; }

    public string? CardholderName { get; set; }

    public bool? IsDefault { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();

    public virtual User User { get; set; } = null!;
}
