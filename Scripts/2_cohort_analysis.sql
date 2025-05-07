SELECT
    cohort_year,
    SUM(total_net_revenue) total_revenue,
    COUNT(DISTINCT customerkey) total_customer,
    SUM(total_net_revenue) / COUNT(DISTINCT customerkey) customer_revenue
FROM cohort_analysis
WHERE
    orderdate = first_purchase_date
GROUP BY
    1;