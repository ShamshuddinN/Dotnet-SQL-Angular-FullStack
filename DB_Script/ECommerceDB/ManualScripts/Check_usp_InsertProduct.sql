DECLARE @RC int
EXECUTE @RC = [dbo].[usp_InsertProduct] 'P-UGS6465', 'Some Product Name', 'This is a detailed description of the product.',
'This is a short description.', 'SKU12345', 29.99, 39.99, 15.00, 1, 'BrandName', 1.5, '10x5x2', 'Red', 'M', 
'http://example.com/image.jpg', 100, 20, 50;

PRINT 'Return Code: ' + CAST(@RC AS varchar);

SELECT * from Products ;