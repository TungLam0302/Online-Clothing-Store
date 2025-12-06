-- 1. Tạo database và chuyển ngữ cảnh
IF DB_ID(N'PRJ_ClotherOnline2') IS NULL
    CREATE DATABASE [PRJ_ClotherOnline2];
GO
USE [PRJ_ClotherOnline2];
GO

-- 2. Bảng Role và dữ liệu mẫu
CREATE TABLE [dbo].[Role] (
    [ID]       INT IDENTITY(1,1) PRIMARY KEY,
    [RoleName] NVARCHAR(50)      NOT NULL
);
INSERT INTO [dbo].[Role] (RoleName) VALUES
    (N'Customer'),
    (N'Admin'),
    (N'Manager');
GO

-- 3. Bảng Status và dữ liệu mẫu
CREATE TABLE [dbo].[Status] (
    [StatusID]   INT IDENTITY(1,1) PRIMARY KEY,
    [StatusName] NVARCHAR(50)      NOT NULL
);
INSERT INTO [dbo].[Status] (StatusName) VALUES
    (N'Pending'),
    (N'Processing'),
    (N'Shipped'),
    (N'Delivered'),
    (N'Cancelled');
GO

-- 4. Bảng User
CREATE TABLE [dbo].[User] (
    [UserID]   INT IDENTITY(1,1) PRIMARY KEY,
    [Email]    NVARCHAR(100)  NOT NULL UNIQUE,
    [Password] NVARCHAR(255)  NOT NULL,
    [Phone]    NVARCHAR(15)   NULL    UNIQUE,
    [Name]     NVARCHAR(100)  NOT NULL,
    [Address]  NVARCHAR(255)  NULL,
    [RoleID]   INT            NOT NULL
        REFERENCES [dbo].[Role](ID),
    [Status]   BIT            NOT NULL
        CONSTRAINT DF_User_Status DEFAULT(1)  -- mặc định Active
);
GO

-- 5. Bảng Brand
CREATE TABLE [dbo].[Brand] (
    [BrandID]   INT IDENTITY(1,1) PRIMARY KEY,
    [BrandName] NVARCHAR(100)      NOT NULL
);
GO

-- 6. Bảng Category
CREATE TABLE [dbo].[Category] (
    [CategoryID]       INT IDENTITY(1,1) PRIMARY KEY,
    [CategoryName]     NVARCHAR(100)      NOT NULL,
    [ParentCategoryID] INT                NULL
        REFERENCES [dbo].[Category](CategoryID)
);
GO

-- 7. Bảng Size
CREATE TABLE [dbo].[Size] (
    [SizeID]   INT IDENTITY(1,1) PRIMARY KEY,
    [SizeName] NVARCHAR(50)       NOT NULL
);
GO

-- 8. Bảng Product
CREATE TABLE [dbo].[Product] (
    [ProductID]  INT IDENTITY(1,1) PRIMARY KEY,
    [Name]       NVARCHAR(255)      NOT NULL,
    [Description] NVARCHAR(MAX)     NULL,
    [Price]      DECIMAL(18,2)      NOT NULL,
    [Status]     BIT                NOT NULL
        CONSTRAINT DF_Product_Status DEFAULT(1),
    [BrandID]    INT                NOT NULL
        REFERENCES [dbo].[Brand](BrandID),
    [CategoryID] INT                NOT NULL
        REFERENCES [dbo].[Category](CategoryID),
    [Thumbnail]  NVARCHAR(255)      NULL
);
GO

-- 9. Bảng ProductItem
CREATE TABLE [dbo].[ProductItem] (
    [ProductItemID] INT IDENTITY(1,1) PRIMARY KEY,
    [ProductID]     INT             NOT NULL
        REFERENCES [dbo].[Product](ProductID),
    [SizeID]        INT             NOT NULL
        REFERENCES [dbo].[Size](SizeID),
    [StockQuantity] INT             NOT NULL
);
GO

-- 10. Bảng Cart
CREATE TABLE [dbo].[Cart] (
    [CartID]        INT IDENTITY(1,1) PRIMARY KEY,
    [UserID]        INT             NOT NULL
        REFERENCES [dbo].[User](UserID),
    [ProductItemID] INT             NOT NULL
        REFERENCES [dbo].[ProductItem](ProductItemID),
    [Quantity]      INT             NOT NULL
);
GO

-- 11. Bảng [Order] và OrderDetail
CREATE TABLE [dbo].[Order] (
    [OrderID]        INT IDENTITY(1,1) PRIMARY KEY,
    [UserID]         INT             NOT NULL
        REFERENCES [dbo].[User](UserID),
    [OrderDate]      DATETIME        NOT NULL
        CONSTRAINT DF_Order_OrderDate DEFAULT(GETDATE()),
    [TotalAmount]    DECIMAL(18,2)   NOT NULL,
    [ShippingAddress] NVARCHAR(255)  NOT NULL,
    [StatusID]       INT             NOT NULL
        REFERENCES [dbo].[Status](StatusID)
        CONSTRAINT DF_Order_StatusID DEFAULT(1)
);
GO

CREATE TABLE [dbo].[OrderDetail] (
    [OrderDetailID] INT IDENTITY(1,1) PRIMARY KEY,
    [OrderID]       INT             NOT NULL
        REFERENCES [dbo].[Order](OrderID),
    [ProductItemID] INT             NOT NULL
        REFERENCES [dbo].[ProductItem](ProductItemID),
    [Quantity]      INT             NOT NULL,
    [Price]         DECIMAL(18,2)   NOT NULL
);
GO

-- 12. Bảng Image
CREATE TABLE [dbo].[Image] (
    [ImageID]  INT IDENTITY(1,1) PRIMARY KEY,
    [ProductID] INT            NOT NULL
        REFERENCES [dbo].[Product](ProductID),
    [ImageURL] NVARCHAR(255)   NOT NULL
);
GO

-- 13. Thêm vài tài khoản mẫu (password chưa hash)
INSERT INTO [dbo].[User] (Email, Password, Phone, Name, Address, RoleID) VALUES
  ('customer3@example.com','pass123',   '0900123456','Pham Van D','123 Lê Lợi, Hà Nội',  1), 
  ('admin2@example.com',   'adminpass', '0900654321','Tran Thi E','456 Nguyễn Huệ, HCM', 2),
  ('manager1@example.com', 'manager123','0912345678','Le Thi F',  '789 Trần Phú, Đà Nẵng',3);
GO
