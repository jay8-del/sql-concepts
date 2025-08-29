-- MVC core 

-- Products 
CREATE TABLE Products (
    ProductId INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Price DECIMAL(18, 2) NOT NULL,
    Quantity INT NOT NULL DEFAULT 0,
    CreatedOn DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedOn DATETIME NULL
);

Select * from PRoducts

CREATE PROCEDURE sp_InsertProduct
    @ProductName NVARCHAR(100),
    @Description NVARCHAR(255),
    @Price DECIMAL(18, 2),
    @Quantity INT
AS
BEGIN
    INSERT INTO Products (ProductName, Description, Price, Quantity, CreatedOn)
    VALUES (@ProductName, @Description, @Price, @Quantity, GETDATE());
    
    SELECT SCOPE_IDENTITY() AS NewProductId;
END


CREATE PROCEDURE sp_UpdateProduct
    @ProductId INT,
    @ProductName NVARCHAR(100),
    @Description NVARCHAR(255),
    @Price DECIMAL(18, 2),			
    @Quantity INT
AS
BEGIN
    UPDATE Products
    SET ProductName = @ProductName,
        Description = @Description,
        Price = @Price,
        Quantity = @Quantity,
        UpdatedOn = GETDATE()
    WHERE ProductId = @ProductId;
END


CREATE PROCEDURE sp_DeleteProduct
    @ProductId INT
AS
BEGIN
    DELETE FROM Products WHERE ProductId = @ProductId;
END


CREATE PROCEDURE sp_GetAllProducts
AS
BEGIN
    SELECT ProductId, ProductName, Description, Price, Quantity, CreatedOn, UpdatedOn
    FROM Products;
END


CREATE PROCEDURE sp_GetProductById
    @ProductId INT
AS
BEGIN
    SELECT ProductId, ProductName, Description, Price, Quantity, CreatedOn, UpdatedOn
    FROM Products
    WHERE ProductId = @ProductId;
END


CREATE TABLE Invoices (
    InvoiceId INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceNumber NVARCHAR(50) NOT NULL,
    CustomerName NVARCHAR(100) NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL,
    CreatedOn DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE InvoiceItems (
    InvoiceItemId INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceId INT NOT NULL FOREIGN KEY REFERENCES Invoices(InvoiceId),
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    Total DECIMAL(18,2) NOT NULL
);

-- Insert Invoice Header
CREATE PROCEDURE sp_InsertInvoice
    @InvoiceNumber NVARCHAR(50),
    @CustomerName NVARCHAR(100),
    @TotalAmount DECIMAL(18,2),
    @NewId INT OUTPUT
AS
BEGIN
    INSERT INTO Invoices (InvoiceNumber, CustomerName, TotalAmount)
    VALUES (@InvoiceNumber, @CustomerName, @TotalAmount);

    SET @NewId = SCOPE_IDENTITY();
END
GO

-- Insert Invoice Item
CREATE PROCEDURE sp_InsertInvoiceItem
    @InvoiceId INT,
    @ProductId INT,
    @Quantity INT,
    @Price DECIMAL(18,2),
    @Total DECIMAL(18,2)
AS
BEGIN
    INSERT INTO InvoiceItems (InvoiceId, ProductId, Quantity, Price, Total)
    VALUES (@InvoiceId, @ProductId, @Quantity, @Price, @Total);
END
GO

-- Get All Invoices
CREATE PROCEDURE sp_GetAllInvoices
AS
BEGIN
    SELECT * FROM Invoices ORDER BY CreatedOn DESC;
END
GO

EXEC sp_GetAllInvoices
-- Get Invoice by Id (with Items)
CREATE PROCEDURE sp_GetInvoiceById
    @InvoiceId INT
AS
BEGIN
    SELECT * FROM Invoices WHERE InvoiceId = @InvoiceId;
    SELECT * FROM InvoiceItems WHERE InvoiceId = @InvoiceId;
END
GO

-- Delete Invoice
CREATE PROCEDURE sp_DeleteInvoice
    @InvoiceId INT
AS
BEGIN
    DELETE FROM InvoiceItems WHERE InvoiceId = @InvoiceId;
    DELETE FROM Invoices WHERE InvoiceId = @InvoiceId;
END
GO

SELECT * FROM InvoiceItems ;
SELECT * FROM Invoices ;

Select * from Products


CREATE PROCEDURE sp_UpdateProductStock
    @ProductId INT,
    @Quantity INT
AS
BEGIN
    UPDATE Products
    SET Quantity = Quantity - @Quantity
    WHERE ProductId = @ProductId AND Quantity >= @Quantity;
END
GO


CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL, -- store hash ideally (but for demo plain text ok)
    Role NVARCHAR(50) NOT NULL
);

-- Insert sample users
INSERT INTO Users (Username, PasswordHash, Role)
VALUES ('admin', 'admin123', 'Admin'),
       ('krishna', 'user123', 'User');
