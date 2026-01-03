using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class VwUserOrderHistory
{
    public int OrderId { get; set; }

    public string OrderNumber { get; set; } = null!;

    public int UserId { get; set; }

    public string FullName { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string OrderStatus { get; set; } = null!;

    public string PaymentStatus { get; set; } = null!;

    public decimal Subtotal { get; set; }

    public decimal TaxAmount { get; set; }

    public decimal ShippingAmount { get; set; }

    public decimal DiscountAmount { get; set; }

    public decimal TotalAmount { get; set; }

    public string Currency { get; set; } = null!;

    public DateTime? OrderDate { get; set; }

    public DateTime? ShippedDate { get; set; }

    public DateTime? DeliveredDate { get; set; }

    public string? TrackingNumber { get; set; }

    public string? Notes { get; set; }

    public int? ItemCount { get; set; }

    public string? PaymentMethod { get; set; }
}
