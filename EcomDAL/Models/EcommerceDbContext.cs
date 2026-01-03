using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace EcomDAL.Models;

public partial class EcommerceDbContext : DbContext
{
    public EcommerceDbContext()
    {
    }

    public EcommerceDbContext(DbContextOptions<EcommerceDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Address> Addresses { get; set; }

    public virtual DbSet<Cart> Carts { get; set; }

    public virtual DbSet<Category> Categories { get; set; }

    public virtual DbSet<Inventory> Inventories { get; set; }

    public virtual DbSet<Order> Orders { get; set; }

    public virtual DbSet<OrderItem> OrderItems { get; set; }

    public virtual DbSet<OrderReview> OrderReviews { get; set; }

    public virtual DbSet<PaymentMethod> PaymentMethods { get; set; }

    public virtual DbSet<Product> Products { get; set; }

    public virtual DbSet<ProductReview> ProductReviews { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<VwCategoryProduct> VwCategoryProducts { get; set; }

    public virtual DbSet<VwOrderDetail> VwOrderDetails { get; set; }

    public virtual DbSet<VwProductDetail> VwProductDetails { get; set; }

    public virtual DbSet<VwSalesReport> VwSalesReports { get; set; }

    public virtual DbSet<VwUserDashboard> VwUserDashboards { get; set; }

    public virtual DbSet<VwUserOrderHistory> VwUserOrderHistories { get; set; }

    public virtual DbSet<WishList> WishLists { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            optionsBuilder.UseSqlServer("Name=ConnectionStrings:ECommerceDB");
        }
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Address>(entity =>
        {
            entity.HasKey(e => e.AddressId).HasName("PK__Addresse__091C2AFB387ED168");

            entity.ToTable(tb => tb.HasTrigger("trg_MaintainDefaultAddress"));

            entity.HasIndex(e => e.AddressType, "IX_Addresses_AddressType");

            entity.HasIndex(e => e.IsDefault, "IX_Addresses_IsDefault");

            entity.HasIndex(e => e.UserId, "IX_Addresses_UserId");

            entity.HasIndex(e => new { e.UserId, e.AddressType, e.IsDefault }, "IX_Addresses_User_Type_Default");

            entity.Property(e => e.AddressLine1).HasMaxLength(255);
            entity.Property(e => e.AddressLine2).HasMaxLength(255);
            entity.Property(e => e.AddressType).HasMaxLength(20);
            entity.Property(e => e.City).HasMaxLength(100);
            entity.Property(e => e.Country).HasMaxLength(100);
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsDefault).HasDefaultValue(false);
            entity.Property(e => e.PostalCode).HasMaxLength(20);
            entity.Property(e => e.State).HasMaxLength(100);
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.User).WithMany(p => p.Addresses)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__Addresses__UserI__48CFD27E");
        });

        modelBuilder.Entity<Cart>(entity =>
        {
            entity.HasKey(e => e.CartId).HasName("PK__Cart__51BCD7B7FC1D5F76");

            entity.ToTable("Cart", tb => tb.HasTrigger("trg_ValidateCartQuantity"));

            entity.HasIndex(e => e.AddedAt, "IX_Cart_AddedAt");

            entity.HasIndex(e => e.UserId, "IX_Cart_UserId");

            entity.HasIndex(e => new { e.UserId, e.ProductId }, "IX_Cart_User_Product");

            entity.HasIndex(e => new { e.UserId, e.ProductId }, "UC_CartUserProduct").IsUnique();

            entity.Property(e => e.AddedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ProductId)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.Quantity).HasDefaultValue(1);
            entity.Property(e => e.UnitPrice).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.Product).WithMany(p => p.Carts)
                .HasForeignKey(d => d.ProductId)
                .HasConstraintName("FK__Cart__ProductId__7D439ABD");

            entity.HasOne(d => d.User).WithMany(p => p.Carts)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__Cart__UserId__7C4F7684");
        });

        modelBuilder.Entity<Category>(entity =>
        {
            entity.HasKey(e => e.CategoryId).HasName("PK__Categori__19093A0B894E5A11");

            entity.ToTable(tb => tb.HasTrigger("trg_UpdateCategoryTimestamp"));

            entity.HasIndex(e => e.IsActive, "IX_Categories_IsActive");

            entity.HasIndex(e => e.ParentCategoryId, "IX_Categories_ParentCategoryId");

            entity.HasIndex(e => e.SortOrder, "IX_Categories_SortOrder");

            entity.HasIndex(e => e.CategoryName, "UQ__Categori__8517B2E036F4D0FB").IsUnique();

            entity.Property(e => e.CategoryName).HasMaxLength(100);
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ImageUrl).HasMaxLength(255);
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.SortOrder).HasDefaultValue(0);
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.ParentCategory).WithMany(p => p.InverseParentCategory)
                .HasForeignKey(d => d.ParentCategoryId)
                .HasConstraintName("FK__Categorie__Paren__5070F446");
        });

        modelBuilder.Entity<Inventory>(entity =>
        {
            entity.HasKey(e => e.InventoryId).HasName("PK__Inventor__F5FDE6B397AD8553");

            entity.ToTable("Inventory");

            entity.HasIndex(e => e.LastStockUpdate, "IX_Inventory_LastStockUpdate");

            entity.HasIndex(e => e.QuantityAvailable, "IX_Inventory_QuantityAvailable");

            entity.HasIndex(e => e.ProductId, "UQ__Inventor__B40CC6CCEFC579D7").IsUnique();

            entity.Property(e => e.LastStockUpdate).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ProductId)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.ReorderLevel).HasDefaultValue(10);
            entity.Property(e => e.ReorderQuantity).HasDefaultValue(50);

            entity.HasOne(d => d.Product).WithOne(p => p.Inventory)
                .HasForeignKey<Inventory>(d => d.ProductId)
                .HasConstraintName("FK__Inventory__Produ__6383C8BA");
        });

        modelBuilder.Entity<Order>(entity =>
        {
            entity.HasKey(e => e.OrderId).HasName("PK__Orders__C3905BCF8F4E2BC0");

            entity.ToTable(tb => tb.HasTrigger("trg_UpdateInventoryOnOrderStatus"));

            entity.HasIndex(e => e.OrderDate, "IX_Orders_OrderDate");

            entity.HasIndex(e => e.OrderStatus, "IX_Orders_OrderStatus");

            entity.HasIndex(e => e.PaymentStatus, "IX_Orders_PaymentStatus");

            entity.HasIndex(e => new { e.OrderStatus, e.OrderDate }, "IX_Orders_Status_Date");

            entity.HasIndex(e => e.TotalAmount, "IX_Orders_TotalAmount");

            entity.HasIndex(e => e.UserId, "IX_Orders_UserId");

            entity.HasIndex(e => new { e.UserId, e.OrderStatus }, "IX_Orders_User_Status");

            entity.HasIndex(e => e.OrderNumber, "UQ__Orders__CAC5E743ED11CF79").IsUnique();

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Currency)
                .HasMaxLength(3)
                .HasDefaultValue("USD");
            entity.Property(e => e.DiscountAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.OrderDate).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.OrderNumber)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.OrderStatus).HasMaxLength(50);
            entity.Property(e => e.PaymentStatus).HasMaxLength(50);
            entity.Property(e => e.ShippingAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Subtotal).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TaxAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TotalAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TrackingNumber).HasMaxLength(100);
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.BillingAddress).WithMany(p => p.OrderBillingAddresses)
                .HasForeignKey(d => d.BillingAddressId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Orders__BillingA__123EB7A3");

            entity.HasOne(d => d.PaymentMethod).WithMany(p => p.Orders)
                .HasForeignKey(d => d.PaymentMethodId)
                .HasConstraintName("FK__Orders__PaymentM__10566F31");

            entity.HasOne(d => d.ShippingAddress).WithMany(p => p.OrderShippingAddresses)
                .HasForeignKey(d => d.ShippingAddressId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Orders__Shipping__114A936A");

            entity.HasOne(d => d.User).WithMany(p => p.Orders)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Orders__UserId__0F624AF8");
        });

        modelBuilder.Entity<OrderItem>(entity =>
        {
            entity.HasKey(e => e.OrderItemId).HasName("PK__OrderIte__57ED0681009B91A9");

            entity.ToTable(tb => tb.HasTrigger("trg_UpdateInventoryOnOrder"));

            entity.HasIndex(e => e.OrderId, "IX_OrderItems_OrderId");

            entity.HasIndex(e => new { e.OrderId, e.ProductId }, "IX_OrderItems_Order_Product");

            entity.HasIndex(e => e.ProductId, "IX_OrderItems_ProductId");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ProductId)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.ProductImage).HasMaxLength(255);
            entity.Property(e => e.ProductName).HasMaxLength(255);
            entity.Property(e => e.TotalPrice).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.UnitPrice).HasColumnType("decimal(18, 2)");

            entity.HasOne(d => d.Order).WithMany(p => p.OrderItems)
                .HasForeignKey(d => d.OrderId)
                .HasConstraintName("FK__OrderItem__Order__160F4887");

            entity.HasOne(d => d.Product).WithMany(p => p.OrderItems)
                .HasForeignKey(d => d.ProductId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__OrderItem__Produ__17036CC0");
        });

        modelBuilder.Entity<OrderReview>(entity =>
        {
            entity.HasKey(e => e.OrderReviewId).HasName("PK__OrderRev__A9AB8407E81D28B6");

            entity.HasIndex(e => e.OrderId, "IX_OrderReviews_OrderId");

            entity.HasIndex(e => e.OverallRating, "IX_OrderReviews_OverallRating");

            entity.HasIndex(e => e.UserId, "IX_OrderReviews_UserId");

            entity.HasIndex(e => e.OrderId, "UQ__OrderRev__C3905BCEB750AE47").IsUnique();

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsPublic).HasDefaultValue(true);
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.Order).WithOne(p => p.OrderReview)
                .HasForeignKey<OrderReview>(d => d.OrderId)
                .HasConstraintName("FK__OrderRevi__Order__208CD6FA");

            entity.HasOne(d => d.User).WithMany(p => p.OrderReviews)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__OrderRevi__UserI__2180FB33");
        });

        modelBuilder.Entity<PaymentMethod>(entity =>
        {
            entity.HasKey(e => e.PaymentMethodId).HasName("PK__PaymentM__DC31C1D3FAF2F895");

            entity.ToTable(tb => tb.HasTrigger("trg_MaintainDefaultPaymentMethod"));

            entity.HasIndex(e => e.IsActive, "IX_PaymentMethods_IsActive");

            entity.HasIndex(e => e.IsDefault, "IX_PaymentMethods_IsDefault");

            entity.HasIndex(e => e.UserId, "IX_PaymentMethods_UserId");

            entity.Property(e => e.AccountNumber).HasMaxLength(255);
            entity.Property(e => e.CardholderName).HasMaxLength(255);
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.IsDefault).HasDefaultValue(false);
            entity.Property(e => e.MethodType).HasMaxLength(50);
            entity.Property(e => e.Provider).HasMaxLength(100);
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.User).WithMany(p => p.PaymentMethods)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__PaymentMe__UserI__75A278F5");
        });

        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasKey(e => e.ProductId).HasName("PK__Products__B40CC6CDD093BF2E");

            entity.ToTable(tb => tb.HasTrigger("trg_UpdateProductTimestamp"));

            entity.HasIndex(e => e.Brand, "IX_Products_Brand");

            entity.HasIndex(e => e.CategoryId, "IX_Products_CategoryId");

            entity.HasIndex(e => new { e.CategoryId, e.IsActive }, "IX_Products_Category_IsActive");

            entity.HasIndex(e => e.CreatedAt, "IX_Products_CreatedAt");

            entity.HasIndex(e => e.Sku, "IX_Products_FTSKey").IsUnique();

            entity.HasIndex(e => e.IsActive, "IX_Products_IsActive");

            entity.HasIndex(e => new { e.IsActive, e.IsFeatured }, "IX_Products_IsActive_IsFeatured");

            entity.HasIndex(e => e.IsFeatured, "IX_Products_IsFeatured");

            entity.HasIndex(e => e.Price, "IX_Products_Price");

            entity.HasIndex(e => e.Sku, "IX_Products_SKU");

            entity.HasIndex(e => e.Sku, "UQ__Products__CA1ECF0D7877FCC2").IsUnique();

            entity.Property(e => e.ProductId)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.AverageRating).HasColumnType("decimal(3, 1)");
            entity.Property(e => e.Brand).HasMaxLength(100);
            entity.Property(e => e.Color).HasMaxLength(50);
            entity.Property(e => e.ComparePrice).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.CostPrice).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Dimensions).HasMaxLength(50);
            entity.Property(e => e.ImageUrl).HasMaxLength(255);
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.IsFeatured).HasDefaultValue(false);
            entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.ProductName).HasMaxLength(255);
            entity.Property(e => e.ShortDescription).HasMaxLength(500);
            entity.Property(e => e.Size).HasMaxLength(50);
            entity.Property(e => e.Sku)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("SKU");
            entity.Property(e => e.TrackInventory).HasDefaultValue(true);
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Weight).HasColumnType("decimal(10, 3)");

            entity.HasOne(d => d.Category).WithMany(p => p.Products)
                .HasForeignKey(d => d.CategoryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Products__Catego__59FA5E80");
        });

        modelBuilder.Entity<ProductReview>(entity =>
        {
            entity.HasKey(e => e.ReviewId).HasName("PK__ProductR__74BC79CEEEF38379");

            entity.ToTable(tb => tb.HasTrigger("trg_UpdateProductRating"));

            entity.HasIndex(e => e.CreatedAt, "IX_ProductReviews_CreatedAt");

            entity.HasIndex(e => e.IsApproved, "IX_ProductReviews_IsApproved");

            entity.HasIndex(e => e.ProductId, "IX_ProductReviews_ProductId");

            entity.HasIndex(e => new { e.ProductId, e.IsApproved }, "IX_ProductReviews_Product_Approved");

            entity.HasIndex(e => e.Rating, "IX_ProductReviews_Rating");

            entity.HasIndex(e => e.UserId, "IX_ProductReviews_UserId");

            entity.HasIndex(e => new { e.ProductId, e.UserId }, "UC_ProductUser").IsUnique();

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.HelpfulCount).HasDefaultValue(0);
            entity.Property(e => e.IsApproved).HasDefaultValue(true);
            entity.Property(e => e.IsVerified).HasDefaultValue(false);
            entity.Property(e => e.ProductId)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.Title).HasMaxLength(255);
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.Product).WithMany(p => p.ProductReviews)
                .HasForeignKey(d => d.ProductId)
                .HasConstraintName("FK__ProductRe__Produ__6D0D32F4");

            entity.HasOne(d => d.User).WithMany(p => p.ProductReviews)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__ProductRe__UserI__6E01572D");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__Roles__8AFACE1AFAC095FF");

            entity.HasIndex(e => e.RoleName, "UQ__Roles__8A2B6160A1513356").IsUnique();

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Description).HasMaxLength(255);
            entity.Property(e => e.RoleName).HasMaxLength(50);
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__Users__1788CC4C6CB1E4C4");

            entity.ToTable(tb => tb.HasTrigger("trg_UpdateUserTimestamp"));

            entity.HasIndex(e => e.CreatedAt, "IX_Users_CreatedAt");

            entity.HasIndex(e => e.Email, "IX_Users_Email");

            entity.HasIndex(e => e.IsActive, "IX_Users_IsActive");

            entity.HasIndex(e => e.RoleId, "IX_Users_RoleId");

            entity.HasIndex(e => e.Email, "UQ__Users__A9D1053417CFEEFF").IsUnique();

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.EmailVerified).HasDefaultValue(false);
            entity.Property(e => e.FullName).HasMaxLength(255);
            entity.Property(e => e.Gender)
                .HasMaxLength(1)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.PasswordHash).HasMaxLength(255);
            entity.Property(e => e.PhoneNumber).HasMaxLength(20);
            entity.Property(e => e.ProfileImgPath).HasMaxLength(255);
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.Role).WithMany(p => p.Users)
                .HasForeignKey(d => d.RoleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Users__RoleId__4222D4EF");
        });

        modelBuilder.Entity<VwCategoryProduct>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("vw_CategoryProducts");

            entity.Property(e => e.AverageRating).HasColumnType("decimal(3, 1)");
            entity.Property(e => e.CategoryName).HasMaxLength(100);
            entity.Property(e => e.ComparePrice).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.DiscountedPrice).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.ImageUrl).HasMaxLength(255);
            entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.ProductId)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.ProductImage).HasMaxLength(255);
            entity.Property(e => e.ProductName).HasMaxLength(255);
            entity.Property(e => e.StockStatus)
                .HasMaxLength(12)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VwOrderDetail>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("vw_OrderDetails");

            entity.Property(e => e.BillingAddressLine1).HasMaxLength(255);
            entity.Property(e => e.BillingCity).HasMaxLength(100);
            entity.Property(e => e.BillingCountry).HasMaxLength(100);
            entity.Property(e => e.BillingPostalCode).HasMaxLength(20);
            entity.Property(e => e.BillingState).HasMaxLength(100);
            entity.Property(e => e.Currency).HasMaxLength(3);
            entity.Property(e => e.DiscountAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.FullName).HasMaxLength(255);
            entity.Property(e => e.OrderNumber)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.OrderStatus).HasMaxLength(50);
            entity.Property(e => e.PaymentMethod).HasMaxLength(50);
            entity.Property(e => e.PaymentStatus).HasMaxLength(50);
            entity.Property(e => e.ProductId)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.ProductImage).HasMaxLength(255);
            entity.Property(e => e.ProductName).HasMaxLength(255);
            entity.Property(e => e.ShippingAddressLine1).HasMaxLength(255);
            entity.Property(e => e.ShippingAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.ShippingCity).HasMaxLength(100);
            entity.Property(e => e.ShippingCountry).HasMaxLength(100);
            entity.Property(e => e.ShippingPostalCode).HasMaxLength(20);
            entity.Property(e => e.ShippingState).HasMaxLength(100);
            entity.Property(e => e.Subtotal).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TaxAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TotalAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TotalPrice).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TrackingNumber).HasMaxLength(100);
            entity.Property(e => e.UnitPrice).HasColumnType("decimal(18, 2)");
        });

        modelBuilder.Entity<VwProductDetail>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("vw_ProductDetails");

            entity.Property(e => e.AverageRating).HasColumnType("decimal(3, 1)");
            entity.Property(e => e.Brand).HasMaxLength(100);
            entity.Property(e => e.CategoryName).HasMaxLength(100);
            entity.Property(e => e.Color).HasMaxLength(50);
            entity.Property(e => e.ComparePrice).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Dimensions).HasMaxLength(50);
            entity.Property(e => e.DiscountedPrice).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.ImageUrl).HasMaxLength(255);
            entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.ProductId)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.ProductName).HasMaxLength(255);
            entity.Property(e => e.ShortDescription).HasMaxLength(500);
            entity.Property(e => e.Size).HasMaxLength(50);
            entity.Property(e => e.Sku)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("SKU");
            entity.Property(e => e.StockStatus)
                .HasMaxLength(12)
                .IsUnicode(false);
            entity.Property(e => e.Weight).HasColumnType("decimal(10, 3)");
        });

        modelBuilder.Entity<VwSalesReport>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("vw_SalesReport");

            entity.Property(e => e.AverageOrderValue).HasColumnType("decimal(38, 6)");
            entity.Property(e => e.TotalRevenue).HasColumnType("decimal(38, 2)");
        });

        modelBuilder.Entity<VwUserDashboard>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("vw_UserDashboard");

            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.FullName).HasMaxLength(255);
            entity.Property(e => e.TotalSpent).HasColumnType("decimal(38, 2)");
        });

        modelBuilder.Entity<VwUserOrderHistory>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("vw_UserOrderHistory");

            entity.Property(e => e.Currency).HasMaxLength(3);
            entity.Property(e => e.DiscountAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.FullName).HasMaxLength(255);
            entity.Property(e => e.OrderNumber)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.OrderStatus).HasMaxLength(50);
            entity.Property(e => e.PaymentMethod).HasMaxLength(50);
            entity.Property(e => e.PaymentStatus).HasMaxLength(50);
            entity.Property(e => e.ShippingAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Subtotal).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TaxAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TotalAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TrackingNumber).HasMaxLength(100);
        });

        modelBuilder.Entity<WishList>(entity =>
        {
            entity.HasKey(e => e.WishListId).HasName("PK__WishList__E41F8787E9DA2615");

            entity.ToTable("WishList");

            entity.HasIndex(e => e.AddedAt, "IX_WishList_AddedAt");

            entity.HasIndex(e => e.UserId, "IX_WishList_UserId");

            entity.HasIndex(e => new { e.UserId, e.ProductId }, "UC_WishListUserProduct").IsUnique();

            entity.Property(e => e.AddedAt).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.ProductId)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.Product).WithMany(p => p.WishLists)
                .HasForeignKey(d => d.ProductId)
                .HasConstraintName("FK__WishList__Produc__02FC7413");

            entity.HasOne(d => d.User).WithMany(p => p.WishLists)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__WishList__UserId__02084FDA");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
