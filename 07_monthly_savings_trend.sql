-- Q7: Monthly 340B Savings Trend
-- Business question: How is total program savings trending month over
-- month? Useful for the dashboard's headline trend line and for spotting
-- seasonality or drop-offs that warrant investigation.

SELECT
    strftime('%Y-%m', c.fill_date) AS claim_month,
    COUNT(c.claim_id) AS eligible_claim_count,
    ROUND(SUM(d.wac_price - d.price_340b), 2) AS total_savings
FROM claims c
JOIN drug_reference d ON c.ndc = d.ndc
WHERE c.eligible_340b = 'Y'
GROUP BY claim_month
ORDER BY claim_month;
