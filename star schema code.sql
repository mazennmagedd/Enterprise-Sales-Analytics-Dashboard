ALTER TABLE gold.fact_online_sales
ADD CONSTRAINT FK_online_customer
FOREIGN KEY (customer_key)
REFERENCES gold.dim_customer(customer_key);

ALTER TABLE gold.fact_online_sales
ADD CONSTRAINT FK_online_product
FOREIGN KEY (product_key)
REFERENCES gold.dim_product(product_key);

ALTER TABLE gold.fact_online_sales
ADD CONSTRAINT FK_online_date
FOREIGN KEY (date_key)
REFERENCES gold.dim_date(date_key);

ALTER TABLE gold.fact_online_sales
ADD CONSTRAINT FK_online_warehouse
FOREIGN KEY (warehouse_key)
REFERENCES gold.dim_warehouse(warehouse_key);

ALTER TABLE gold.fact_online_sales
ADD CONSTRAINT FK_online_promotion
FOREIGN KEY (promotion_key)
REFERENCES gold.dim_promotion(promotion_key);



ALTER TABLE gold.fact_pos_sales
ADD CONSTRAINT FK_pos_customer
FOREIGN KEY (customer_key)
REFERENCES gold.dim_customer(customer_key);

ALTER TABLE gold.fact_pos_sales
ADD CONSTRAINT FK_pos_product
FOREIGN KEY (product_key)
REFERENCES gold.dim_product(product_key);

ALTER TABLE gold.fact_pos_sales
ADD CONSTRAINT FK_pos_date
FOREIGN KEY (date_key)
REFERENCES gold.dim_date(date_key);

ALTER TABLE gold.fact_pos_sales
ADD CONSTRAINT FK_pos_store
FOREIGN KEY (store_key)
REFERENCES gold.dim_store(store_key);

ALTER TABLE gold.fact_pos_sales
ADD CONSTRAINT FK_pos_employee
FOREIGN KEY (employee_key)
REFERENCES gold.dim_employee(employee_key);

ALTER TABLE gold.fact_pos_sales
ADD CONSTRAINT FK_pos_promotion
FOREIGN KEY (promotion_key)
REFERENCES gold.dim_promotion(promotion_key);