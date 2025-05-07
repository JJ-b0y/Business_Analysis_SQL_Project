SELECT
	cohort_year,
	COUNT(DISTINCT customerkey) customer_count,
	SUM(total_net_revenue) total_revenue,
	SUM(total_net_revenue) / COUNT(DISTINCT customerkey) customer_revenue
FROM
	cohort_analysis
GROUP BY
	1;