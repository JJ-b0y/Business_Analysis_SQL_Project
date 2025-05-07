WITH customer_ltv AS
(
SELECT
	customerkey,
	cleaned_name,
	SUM(total_net_revenue) total_ltv
FROM
	cohort_analysis
GROUP BY
	1,2
),
customer_segments AS
(
SELECT
	PERCENTILE_CONT(.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_25th_percentile,
	PERCENTILE_CONT(.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_75th_percentile
FROM
	customer_ltv
),
segment_values AS
(
SELECT
	cl.*,
	CASE
		WHEN cl.total_ltv < cs.ltv_25th_percentile THEN '3-Low-Value'
		WHEN cl.total_ltv <= cs.ltv_75th_percentile THEN '2-Mid-Value'
		ELSE '1-High-Value'
		END AS customer_segment
FROM
	customer_ltv cl,
	customer_segments cs
)
SELECT 
	sv.customer_segment,
	COUNT(sv.customerkey) customer_count,
	sum(sv.total_ltv) total_ltv,
	sum(sv.total_ltv) / COUNT(sv.customerkey) avg_ltv
FROM
	segment_values sv
GROUP BY
	1
ORDER BY 
	1;