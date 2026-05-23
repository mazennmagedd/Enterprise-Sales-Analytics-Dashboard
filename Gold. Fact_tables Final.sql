USE DataWarehouse;
GO

IF OBJECT_ID('gold.fact_online_sales') IS NOT NULL
    DROP TABLE gold.fact_online_sales;
GO

CREATE TABLE gold.fact_online_sales (
    customer_key   INT NOT NULL,
    product_key    INT NOT NULL,
    date_key       INT NOT NULL,
    warehouse_key  INT NOT NULL,
    promotion_key  INT NULL,
    quantity       INT NOT NULL,
    unit_price     DECIMAL(12,2) NOT NULL,
    total_amount   DECIMAL(14,2) NOT NULL
);
GO



INSERT INTO gold.fact_online_sales
SELECT
    dc.customer_key,
    dp.product_key,
    dd.date_key,
    dw.warehouse_key,
    dpromo.promotion_key,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS total_amount

FROM silver.online_order_items oi
JOIN silver.online_orders o 
    ON oi.order_id = o.order_id
JOIN gold.dim_customer dc 
    ON o.customer_id = dc.customer_id
JOIN gold.dim_product dp 
    ON oi.product_id = dp.product_id
JOIN gold.dim_date dd 
    ON CAST(o.order_time AS DATE) = dd.full_date
JOIN gold.dim_warehouse dw 
    ON o.warehouse_id = dw.warehouse_id
LEFT JOIN gold.dim_promotion dpromo 
    ON oi.promotion_id = dpromo.promotion_id

WHERE 
    oi.unit_price IS NOT NULL
    AND oi.quantity IS NOT NULL;


SELECT COUNT(*) FROM gold.fact_online_sales;
SELECT TOP 10 * FROM gold.fact_online_sales;
SELECT *
FROM gold.fact_online_sales
WHERE 
    customer_key IS NULL OR
    product_key IS NULL OR
    date_key IS NULL OR
    warehouse_key IS NULL;



IF OBJECT_ID('gold.fact_pos_sales') IS NOT NULL
    DROP TABLE gold.fact_pos_sales;
GO

CREATE TABLE gold.fact_pos_sales (
    customer_key   INT NOT NULL,
    product_key    INT NOT NULL,
    date_key       INT NOT NULL,
    store_key      INT NOT NULL,
    employee_key   INT NOT NULL,
    promotion_key  INT NULL,
    quantity       INT NOT NULL,
    unit_price     DECIMAL(12,2) NOT NULL,
    total_amount   DECIMAL(14,2) NOT NULL
);
GO






INSERT INTO gold.fact_pos_sales
SELECT
    dc.customer_key,
    dp.product_key,
    dd.date_key,
    ds.store_key,
    de.employee_key,
    dpromo.promotion_key,
    ti.quantity,
    ti.unit_price,
    ti.quantity * ti.unit_price AS total_amount

FROM silver.transaction_items ti
JOIN silver.pos_transactions pt 
    ON ti.transaction_id = pt.transaction_id
JOIN gold.dim_customer dc 
    ON pt.customer_id = dc.customer_id
JOIN gold.dim_product dp 
    ON ti.product_id = dp.product_id
JOIN gold.dim_date dd 
    ON CAST(pt.transaction_time AS DATE) = dd.full_date
JOIN gold.dim_store ds 
    ON pt.store_id = ds.store_id
JOIN gold.dim_employee de 
    ON pt.employee_id = de.employee_id
LEFT JOIN gold.dim_promotion dpromo 
    ON ti.promotion_id = dpromo.promotion_id

WHERE 
    ti.unit_price IS NOT NULL
    AND ti.quantity IS NOT NULL;



SELECT COUNT(*) FROM gold.fact_pos_sales;

SELECT *
FROM gold.fact_pos_sales
WHERE 
    customer_key IS NULL OR
    product_key IS NULL OR
    date_key IS NULL OR
    store_key IS NULL OR
    employee_key IS NULL;
