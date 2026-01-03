using System;
using System.Collections.Generic;

namespace EcomDAL.Models;

public partial class VwOrderDetail
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

    public int OrderItemId { get; set; }

    public string ProductId { get; set; } = null!;

    public string ProductName { get; set; } = null!;

    public int Quantity { get; set; }

    public decimal UnitPrice { get; set; }

    public decimal TotalPrice { get; set; }

    public string? ProductImage { get; set; }

    public string ShippingAddressLine1 { get; set; } = null!;

    public string ShippingCity { get; set; } = null!;

    public string ShippingState { get; set; } = null!;

    public string ShippingPostalCode { get; set; } = null!;

    public string ShippingCountry { get; set; } = null!;

    public string BillingAddressLine1 { get; set; } = null!;

    public string BillingCity { get; set; } = null!;

    public string BillingState { get; set; } = null!;

    public string BillingPostalCode { get; set; } = null!;

    public string BillingCountry { get; set; } = null!;

    public string? PaymentMethod { get; set; }
}
