WITH customer_purchase_stamp AS
(
SELECT
	cohort_year,
	customerkey,
	cleaned_name,
	orderdate,
	row_number() OVER(PARTITION BY customerkey ORDER BY orderdate DESC) rn,
	first_purchase_date
FROM
	cohort_analysis
), churned_customers AS
(
SELECT
	cohort_year,
	customerkey,
	cleaned_name,
	orderdate AS last_purchase_date,
	CASE
		WHEN orderdate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months' THEN 'Churned' -- purchases PRIOR TO 6 months OF the LAST orderdate ON record
		ELSE 'Active'
	END AS customer_status
FROM
	customer_purchase_stamp
WHERE rn = 1 -- returns ONLY LAST purchase FOR EACH customerkey
	AND first_purchase_date < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months'
)
SELECT
	cohort_year,
	customer_status,
	COUNT(customerkey) num_customers,
	SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year) total_customers,
	ROUND(COUNT(customerkey) / SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year), 2) status_percentage
FROM
	churned_customers
GROUP BY
	1,2;