-- =============================================
-- Seed Data Insertion Script
-- =============================================

-- Insert Roles
INSERT INTO Roles (RoleName, Description) VALUES 
('Admin', 'System administrator with full access'),
('Customer', 'Regular customer with standard purchasing privileges'),
('Premium', 'Premium customer with additional benefits and discounts'),
('Vendor', 'Vendor/Seller who can manage their own products'),
('Moderator', 'Content moderator who can manage reviews and user-generated content');
GO

-- Insert Categories
INSERT INTO Categories (CategoryName, Description, ParentCategoryId, ImageUrl, SortOrder) VALUES 
('Electronics', 'Electronic devices and accessories', NULL, '/images/categories/electronics.jpg', 1),
('Computers', 'Laptops, desktops, and computer accessories', 1, '/images/categories/computers.jpg', 1),
('Smartphones', 'Mobile phones and smartphones', 1, '/images/categories/smartphones.jpg', 2),
('Audio', 'Headphones, speakers, and audio equipment', 1, '/images/categories/audio.jpg', 3),
('Cameras', 'Digital cameras and photography equipment', 1, '/images/categories/cameras.jpg', 4),
('Clothing', 'Fashion and apparel for all ages', NULL, '/images/categories/clothing.jpg', 2),
('Men''s Clothing', 'Clothing and accessories for men', 6, '/images/categories/mens-clothing.jpg', 1),
('Women''s Clothing', 'Clothing and accessories for women', 6, '/images/categories/womens-clothing.jpg', 2),
('Kids'' Clothing', 'Clothing and accessories for children', 6, '/images/categories/kids-clothing.jpg', 3),
('Home & Garden', 'Home decor, furniture, and garden supplies', NULL, '/images/categories/home-garden.jpg', 3),
('Furniture', 'Indoor and outdoor furniture', 10, '/images/categories/furniture.jpg', 1),
('Kitchen', 'Kitchen appliances and cookware', 10, '/images/categories/kitchen.jpg', 2),
('Garden', 'Garden tools and outdoor supplies', 10, '/images/categories/garden.jpg', 3),
('Sports & Outdoors', 'Sports equipment and outdoor gear', NULL, '/images/categories/sports-outdoors.jpg', 4),
('Fitness', 'Exercise equipment and fitness accessories', 14, '/images/categories/fitness.jpg', 1),
('Outdoor Gear', 'Camping, hiking, and outdoor equipment', 14, '/images/categories/outdoor-gear.jpg', 2);
GO

-- Insert Products
INSERT INTO Products (ProductId, ProductName, Description, ShortDescription, SKU, Price, ComparePrice, CategoryId, Brand, Weight, Color, ImageUrl, IsActive, IsFeatured) VALUES 
('ELEC001', 'iPhone 15 Pro Max', 'The latest iPhone with advanced camera system and A17 Pro chip. Features titanium design, USB-C connectivity, and improved battery life.', 'Premium smartphone with pro-grade camera system', 'IP15PM256', 1199.99, 1299.99, 2, 'Apple', 0.221, 'Natural Titanium', '/images/products/iphone-15-pro.jpg', 1, 1),
('ELEC002', 'Samsung Galaxy S24 Ultra', 'Flagship Android smartphone with S Pen, 200MP camera, and Galaxy AI features. Built for productivity and creativity.', 'Premium Android smartphone with S Pen', 'SGS24U512', 1299.99, 1399.99, 2, 'Samsung', 0.234, 'Phantom Black', '/images/products/galaxy-s24-ultra.jpg', 1, 1),
('ELEC003', 'MacBook Pro 14"', 'Powerful laptop with M3 Pro chip, brilliant Liquid Retina XDR display, and all-day battery life. Perfect for professionals.', 'High-performance laptop for creative professionals', 'MBP14M3', 1999.99, 2199.99, 1, 'Apple', 1.6, 'Space Gray', '/images/products/macbook-pro-14.jpg', 1, 1),
('ELEC004', 'Sony WH-1000XM5', 'Industry-leading noise canceling headphones with exceptional sound quality and up to 30 hours of battery life.', 'Premium noise-canceling wireless headphones', 'SNYWH1000XM5', 399.99, 449.99, 3, 'Sony', 0.25, 'Black', '/images/products/sony-wh1000xm5.jpg', 1, 0),
('ELEC005', 'Canon EOS R6 Mark II', 'Full-frame mirrorless camera with 24.2MP sensor, advanced autofocus, and 8K video recording.', 'Professional full-frame mirrorless camera', 'CNEOSR6M2', 2499.99, 2699.99, 4, 'Canon', 0.588, 'Black', '/images/products/canon-eos-r6.jpg', 1, 0),
('CLOTH001', 'Men''s Premium Cotton T-Shirt', 'Soft and comfortable 100% cotton t-shirt. Perfect for everyday wear with a classic fit that never goes out of style.', 'Classic cotton t-shirt for men', 'MTS001L', 29.99, 39.99, 7, 'Basics Co', 0.18, 'White', '/images/products/mens-tshirt.jpg', 1, 0),
('CLOTH002', 'Women''s Silk Blouse', 'Elegant silk blouse with button-front design. Perfect for office wear or special occasions with a luxurious feel.', 'Elegant women''s silk blouse', 'WSB001M', 89.99, 119.99, 8, 'Elegance', 0.25, 'Ivory', '/images/products/womens-silk-blouse.jpg', 1, 0),
('CLOTH003', 'Kids Denim Jeans', 'Durable denim jeans for kids with adjustable waistband. Comfortable fit for all-day play and activities.', 'Comfortable denim jeans for children', 'KDJ0016', 39.99, 49.99, 9, 'KidsWear', 0.3, 'Blue', '/images/products/kids-denim.jpg', 1, 0),
('HOME001', 'Modern Sectional Sofa', 'Stylish L-shaped sectional sofa with comfortable cushions and modern design. Perfect for living rooms and entertainment spaces.', 'Modern L-shaped sectional sofa', 'MSS001GRY', 899.99, 1199.99, 11, 'Comfort Living', 75.0, 'Gray', '/images/products/sectional-sofa.jpg', 1, 0),
('HOME002', 'Stainless Steel Refrigerator', 'Spacious 28 cu. ft. French door refrigerator with ice and water dispenser. Energy Star certified with modern design.', 'Large capacity French door refrigerator', 'SSRF28', 1599.99, 1899.99, 12, 'CoolHome', 220.0, 'Stainless Steel', '/images/products/refrigerator.jpg', 1, 0),
('HOME003', 'Professional Chef Knife Set', '6-piece professional knife set with wooden block. Includes essential knives for all your kitchen cutting needs.', 'Professional kitchen knife set', 'PCKS001', 149.99, 199.99, 12, 'ChefPro', 2.5, 'Silver', '/images/products/knife-set.jpg', 1, 0),
('SPORT001', 'Adjustable Dumbbell Set', 'Space-saving adjustable dumbbells from 5 to 50 lbs. Perfect for home workouts with quick weight change system.', 'Adjustable dumbbell set for home fitness', 'ADS50', 299.99, 399.99, 15, 'FitGear', 50.0, 'Black/Red', '/images/products/dumbbell-set.jpg', 1, 0),
('SPORT002', '4-Person Tent', 'Waterproof 4-person camping tent with easy setup. Features multiple windows and ventilation for comfortable camping.', 'Spacious 4-person camping tent', 'TENT4P', 129.99, 169.99, 16, 'OutdoorLife', 8.2, 'Green/Gray', '/images/products/camping-tent.jpg', 1, 0);
GO

-- Insert Inventory records
INSERT INTO Inventory (ProductId, QuantityAvailable, QuantityReserved, ReorderLevel, ReorderQuantity) VALUES 
('ELEC001', 50, 0, 10, 25),
('ELEC002', 45, 0, 10, 25),
('ELEC003', 30, 0, 5, 15),
('ELEC004', 75, 0, 15, 40),
('ELEC005', 20, 0, 5, 10),
('CLOTH001', 200, 0, 50, 100),
('CLOTH002', 80, 0, 20, 40),
('CLOTH003', 150, 0, 30, 75),
('HOME001', 15, 0, 3, 8),
('HOME002', 25, 0, 5, 15),
('HOME003', 60, 0, 15, 30),
('SPORT001', 40, 0, 10, 20),
('SPORT002', 55, 0, 12, 30);
GO

-- Insert Sample Users
INSERT INTO Users (Email, PasswordHash, FullName, Gender, DateOfBirth, RoleId, PhoneNumber, IsActive, EmailVerified) VALUES 
('admin@ecommerce.com', '$2a$10$hashedpassword123', 'System Administrator', 'O', '1985-05-15', 1, '+1234567890', 1, 1),
('john.doe@email.com', '$2a$10$hashedpassword456', 'John Doe', 'M', '1990-03-22', 2, '+1234567891', 1, 1),
('jane.smith@email.com', '$2a$10$hashedpassword789', 'Jane Smith', 'F', '1988-07-18', 3, '+1234567892', 1, 1),
('mike.wilson@email.com', '$2a$10$hashedpassword012', 'Mike Wilson', 'M', '1992-11-30', 2, '+1234567893', 1, 0),
('sarah.johnson@email.com', '$2a$10$hashedpassword345', 'Sarah Johnson', 'F', '1995-02-14', 2, '+1234567894', 1, 1);
GO

-- Insert Addresses for users
INSERT INTO Addresses (UserId, AddressLine1, AddressLine2, City, State, PostalCode, Country, AddressType, IsDefault) VALUES 
(1000, '123 Main St', 'Apt 4B', 'New York', 'NY', '10001', 'USA', 'Both', 1),
(1001, '456 Oak Avenue', NULL, 'Los Angeles', 'CA', '90001', 'USA', 'Shipping', 1),
(1001, '456 Oak Avenue', NULL, 'Los Angeles', 'CA', '90001', 'USA', 'Billing', 0),
(1002, '789 Pine Road', 'Suite 200', 'Chicago', 'IL', '60601', 'USA', 'Both', 1),
(1003, '321 Elm Street', NULL, 'Houston', 'TX', '77001', 'USA', 'Both', 1);
GO

-- Insert Payment Methods
INSERT INTO PaymentMethods (UserId, MethodType, Provider, AccountNumber, ExpiryDate, CardholderName, IsDefault, IsActive) VALUES 
(1000, 'Credit Card', 'Visa', '****-****-****-1234', '2025-12-31', 'John Doe', 1, 1),
(1001, 'Credit Card', 'Mastercard', '****-****-****-5678', '2026-08-31', 'Jane Smith', 1, 1),
(1002, 'PayPal', 'PayPal', 'mike.wilson@email.com', NULL, NULL, 1, 1),
(1003, 'Credit Card', 'American Express', '****-****-****-9012', '2024-11-30', 'Sarah Johnson', 1, 1);
GO

-- Insert Product Reviews
INSERT INTO ProductReviews (ProductId, UserId, Rating, Title, ReviewText, IsVerified, IsApproved) VALUES 
('ELEC001', 1000, 5, 'Amazing Phone!', 'The iPhone 15 Pro Max exceeded my expectations. The camera quality is outstanding and the battery life is incredible. Highly recommend!', 1, 1),
('ELEC002', 1001, 4, 'Great Android Phone', 'Very happy with the Galaxy S24 Ultra. The S Pen is extremely useful for work. Only minor issue is the weight, but overall excellent device.', 1, 1),
('ELEC003', 1003, 5, 'Perfect for Creative Work', 'As a graphic designer, this MacBook Pro is exactly what I needed. The display is gorgeous and performance is flawless. Worth every penny!', 1, 1),
('ELEC004', 1000, 4, 'Excellent Sound Quality', 'These headphones are amazing for music and calls. The noise cancellation is top-notch. Only wish they were a bit more comfortable for long sessions.', 1, 1),
('CLOTH001', 1002, 3, 'Good Basic T-Shirt', 'Decent quality t-shirt for the price. Fits well and is comfortable. After several washes, it has held up reasonably well.', 1, 1);
GO

-- Insert Sample Orders
INSERT INTO Orders (OrderNumber, UserId, OrderStatus, PaymentStatus, PaymentMethodId, Subtotal, TaxAmount, ShippingAmount, TotalAmount, ShippingAddressId, BillingAddressId, OrderDate) VALUES 
('ORD20231201001', 1000, 'Delivered', 'Paid', 1, 1299.99, 103.99, 0.00, 1403.98, 1, 1, '2023-12-01 10:30:00'),
('ORD20231202001', 1001, 'Shipped', 'Paid', 2, 899.99, 71.99, 9.99, 981.97, 2, 3, '2023-12-02 14:15:00'),
('ORD20231203001', 1003, 'Processing', 'Pending', 4, 399.99, 31.99, 9.99, 441.97, 4, 4, '2023-12-03 09:45:00');
GO

-- Insert Order Items
INSERT INTO OrderItems (OrderId, ProductId, Quantity, UnitPrice, TotalPrice, ProductName, ProductImage) VALUES 
(1, 'ELEC001', 1, 1199.99, 1199.99, 'iPhone 15 Pro Max', '/images/products/iphone-15-pro.jpg'),
(1, 'ELEC004', 1, 399.99, 399.99, 'Sony WH-1000XM5', '/images/products/sony-wh1000xm5.jpg'),
(2, 'ELEC003', 1, 1999.99, 1999.99, 'MacBook Pro 14"', '/images/products/macbook-pro-14.jpg'),
(3, 'ELEC002', 1, 1299.99, 1299.99, 'Samsung Galaxy S24 Ultra', '/images/products/galaxy-s24-ultra.jpg'),
(3, 'CLOTH001', 2, 29.99, 59.98, 'Men''s Premium Cotton T-Shirt', '/images/products/mens-tshirt.jpg');
GO

-- Insert WishList items
INSERT INTO WishList (UserId, ProductId) VALUES 
(1001, 'ELEC003'),
(1000, 'ELEC005'),
(1001, 'HOME001'),
(1002, 'SPORT001'),
(1003, 'CLOTH002');
GO

-- Insert Cart items
INSERT INTO Cart (UserId, ProductId, Quantity, UnitPrice) VALUES 
(1002, 'CLOTH001', 2, 29.99),
(1003, 'ELEC004', 1, 399.99),
(1001, 'SPORT002', 1, 129.99);
GO