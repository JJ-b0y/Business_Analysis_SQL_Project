WITH sales_data AS
(
SELECT 
	customerkey,
	SUM(quantity * netprice / exchangerate) net_revenue
FROM
	sales
GROUP BY
	1
)
SELECT
	AVG(sd.net_revenue) spending_customers_avg_net_revenue,
	AVG(COALESCE(sd.net_revenue, 0)) all_customers_avg_customer_revenue
FROM
	customer c
LEFT JOIN sales_data sd
	ON c.customerkey = sd.customerkey