-- Q5: Top Drugs (NDCs) by Total 340B Savings Volume
-- Business question: Which drugs are driving the most 340B savings across
-- the program? Useful for prioritizing formulary and contract review.

SELECT
    d.ndc,
    d.drug_name,
    COUNT(c.claim_id) AS eligible_claim_count,
    ROUND(SUM(d.wac_price - d.price_340b), 2) AS total_savings,
    ROUND(AVG(d.wac_price - d.price_340b), 2) AS avg_savings_per_claim
FROM claims c
JOIN drug_reference d ON c.ndc = d.ndc
WHERE c.eligible_340b = 'Y'
GROUP BY d.ndc, d.drug_name
ORDER BY total_savings DESC;
