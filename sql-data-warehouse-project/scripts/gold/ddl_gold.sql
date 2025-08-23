/*
  The purpose of this script is to create views for the Gold layer.
  The Gold Layer represents the final dimension and fact tables.
  Each view is responsible for transforming and combining data from the Silver Layer to produce clean, and business-ready data.
*/

-- CUSTOMER DIMENSION
CREATE VIEW Gold.dim_customers AS
	SELECT  ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
			ci.cst_id AS customer_id,
			ci.cst_key AS customer_number,
			ci.cst_firstname AS first_name,
			ci.cst_lastname AS last_name,
			la.cntry AS country,
			ci.cst_marital_status AS marital_status,
			CASE WHEN ci.cst_gnder <> 'n/a' THEN ci.cst_gnder
				 ELSE COALESCE(ca.gen, 'n/a')
			END AS gender,
			ca.bdate AS birthdate,
			ci.cst_create_date AS created_date
	FROM Silver.crm_cust_info ci
	LEFT JOIN Silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
	LEFT JOIN Silver.erp_loc_a101 la
	ON ci.cst_key = la.cid;

-- checking if the joins where successful and there is no duplication
/*
SELECT cst_id, COUNT(*) FROM(
SELECT  ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_marital_status,
		ci.cst_gnder,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		la.cntry
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_loc_a101 la
ON ci.cst_key = la.cid)t 
GROUP BY cst_id 
HAVING COUNT(*) > 1;
*/


-- PRODUCT DIMENSION
CREATE VIEW Gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- surrogate key
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintainance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM Silver.crm_prd_info pn
LEFT JOIN Silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL; -- gets current product data

-- check if the join was successful
/*
SELECT prd_key, COUNT(*) FROM (
SELECT 
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintainance
FROM Silver.crm_prd_info pn
LEFT JOIN Silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- gets current product data
)t GROUP BY prd_key HAVING COUNT(*) > 1;
*/


CREATE VIEW Gold.fact_sales AS
SELECT 
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM Silver.crm_sales_details sd
LEFT JOIN Gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN Gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id;

-- Check for data completeness
SELECT * FROM Gold.fact_sales s
LEFT JOIN Gold.dim_products p
ON s.product_key = p.product_key
LEFT JOIN Gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE p.product_key IS NULL
