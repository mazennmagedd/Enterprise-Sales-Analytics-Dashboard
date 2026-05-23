USE DataWarehouse;
GO


IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
END;
GO

IF OBJECT_ID('gold.dim_customer') IS NOT NULL
    DROP TABLE gold.dim_customer;
GO

CREATE TABLE gold.dim_customer (
    customer_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    gender NVARCHAR(20),
    city NVARCHAR(100),
    loyalty_level NVARCHAR(50),
    email NVARCHAR(200)
);
GO

INSERT INTO gold.dim_customer
(
    customer_id,
    first_name,
    last_name,
    gender,
    city,
    loyalty_level,
    email
)

SELECT DISTINCT
    customer_id,
    LTRIM(RTRIM(first_name)),
    LTRIM(RTRIM(last_name)),

    CASE 
        WHEN gender IN ('M','Male') THEN 'Male'
        WHEN gender IN ('F','Female') THEN 'Female'
        ELSE 'Unknown'
    END,

    LTRIM(RTRIM(city)),
    LTRIM(RTRIM(loyalty_level)),
    LTRIM(RTRIM(email))

FROM silver.customers;
GO


IF OBJECT_ID('gold.dim_product') IS NOT NULL
    DROP TABLE gold.dim_product;
GO

CREATE TABLE gold.dim_product (
    product_key   INT IDENTITY(1,1) PRIMARY KEY,  -- surrogate key
    product_id    INT,                            -- business key
    sku           NVARCHAR(100),                  
    product_name  NVARCHAR(200),
    brand_id      INT,
    department_id INT,
    package_size  NVARCHAR(100)
);
GO


INSERT INTO gold.dim_product
(
    product_id,
    sku,
    product_name,
    brand_id,
    department_id,
    package_size
)
SELECT DISTINCT
    product_id,
    LTRIM(RTRIM(SKU)),
    LTRIM(RTRIM(product_name)),
    brand_id,
    department_id,
    LTRIM(RTRIM(package_size))
FROM silver.products;


IF OBJECT_ID('gold.dim_store') IS NOT NULL
    DROP TABLE gold.dim_store;
GO

CREATE TABLE gold.dim_store (
    store_key INT IDENTITY(1,1) PRIMARY KEY,  -- surrogate key
    store_id INT,                             -- business key
    store_name NVARCHAR(200),
    city NVARCHAR(100),
    region NVARCHAR(100),
    state NVARCHAR(100),
    opening_date DATE
);
GO

INSERT INTO gold.dim_store
(
    store_id,
    store_name,
    city,
    region,
    state,
    opening_date
)
SELECT DISTINCT
    store_id,
    LTRIM(RTRIM(store_name)),
    LTRIM(RTRIM(city)),
    LTRIM(RTRIM(region)),
    LTRIM(RTRIM(state)),
    CAST(opening_date AS DATE)
FROM silver.stores;



IF OBJECT_ID('gold.dim_warehouse') IS NOT NULL
    DROP TABLE gold.dim_warehouse;
GO

CREATE TABLE gold.dim_warehouse (
    warehouse_key INT IDENTITY(1,1) PRIMARY KEY,  -- surrogate key
    warehouse_id INT,                             -- business key
    warehouse_name NVARCHAR(200),
    city NVARCHAR(100),
    state NVARCHAR(100)
);
GO


INSERT INTO gold.dim_warehouse
(
    warehouse_id,
    warehouse_name,
    city,
    state
)
SELECT DISTINCT
    warehouse_id,
    LTRIM(RTRIM(warehouse_name)),
    LTRIM(RTRIM(city)),
    LTRIM(RTRIM(state))
FROM silver.warehouses;


IF OBJECT_ID('gold.dim_promotion') IS NOT NULL
    DROP TABLE gold.dim_promotion;
GO

CREATE TABLE gold.dim_promotion (
    promotion_key INT IDENTITY(1,1) PRIMARY KEY,  -- surrogate key
    promotion_id INT,                             -- business key
    promo_type NVARCHAR(100),
    discount_percent DECIMAL(5,2),
    start_date DATE,
    end_date DATE
);
GO

INSERT INTO gold.dim_promotion
(
    promotion_id,
    promo_type,
    discount_percent,
    start_date,
    end_date
)
SELECT DISTINCT
    promotion_id,
    LTRIM(RTRIM(promo_type)),
    CAST(discount_percent AS DECIMAL(5,2)),
    CAST(start_date AS DATE),
    CAST(end_date AS DATE)
FROM silver.promotions;



IF OBJECT_ID('gold.dim_employee') IS NOT NULL
    DROP TABLE gold.dim_employee;
GO

CREATE TABLE gold.dim_employee (
    employee_key INT IDENTITY(1,1) PRIMARY KEY,  -- surrogate key
    employee_id INT,                             -- business key
    name NVARCHAR(200),
    gender NVARCHAR(20),
    position NVARCHAR(100),
    store_id INT,
    hire_date DATE
);
GO



INSERT INTO gold.dim_employee
(
    employee_id,
    name,
    gender,
    position,
    store_id,
    hire_date
)
SELECT DISTINCT
    employee_id,
    LTRIM(RTRIM(name)),
    CASE 
        WHEN gender IN ('M','Male') THEN 'Male'
        WHEN gender IN ('F','Female') THEN 'Female'
        ELSE 'Unknown'
    END,
    LTRIM(RTRIM(position)),
    store_id,
    CAST(hire_date AS DATE)
FROM silver.employees;


IF OBJECT_ID('gold.dim_date') IS NOT NULL
    DROP TABLE gold.dim_date;
GO

CREATE TABLE gold.dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    year INT,
    quarter INT,
    month INT,
    day INT,
    day_name NVARCHAR(20)
);
GO

DECLARE @start_date DATE = '2018-01-01';
DECLARE @end_date DATE = '2025-12-31';

WHILE @start_date <= @end_date
BEGIN
    INSERT INTO gold.dim_date
    VALUES (
        CONVERT(INT, FORMAT(@start_date, 'yyyyMMdd')),
        @start_date,
        YEAR(@start_date),
        DATEPART(QUARTER, @start_date),
        MONTH(@start_date),
        DAY(@start_date),
        DATENAME(WEEKDAY, @start_date)
    );

    SET @start_date = DATEADD(DAY, 1, @start_date);
END;
GO


SELECT COUNT(*) FROM gold.dim_date;