-- Q1: 340B Savings Capture Rate by Covered Entity
-- Business question: Which entities are generating the most 340B savings,
-- and what % of their eligible claims actually captured 340B pricing?

SELECT
    ce.entity_id,
    ce.entity_name,
    ce.entity_type,
    COUNT(c.claim_id) AS total_claims,
    SUM(CASE WHEN c.eligible_340b = 'Y' THEN 1 ELSE 0 END) AS eligible_claims,
    ROUND(100.0 * SUM(CASE WHEN c.eligible_340b = 'Y' THEN 1 ELSE 0 END) / COUNT(c.claim_id), 1) AS pct_captured_340b,
    ROUND(SUM(CASE WHEN c.eligible_340b = 'Y' THEN (d.wac_price - d.price_340b) ELSE 0 END), 2) AS total_savings_generated
FROM claims c
JOIN covered_entities ce ON c.entity_id = ce.entity_id
JOIN drug_reference d ON c.ndc = d.ndc
GROUP BY ce.entity_id, ce.entity_name, ce.entity_type
ORDER BY total_savings_generated DESC;
