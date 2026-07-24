-- Q8: Savings and Volume by Covered Entity Type
-- Business question: How does 340B performance differ across entity types
-- (DSH hospitals, CAHs, FQHCs, Ryan White clinics)? Useful for portfolio-
-- level reporting to leadership.

SELECT
    ce.entity_type,
    COUNT(DISTINCT ce.entity_id) AS num_entities,
    COUNT(c.claim_id) AS total_claims,
    ROUND(SUM(CASE WHEN c.eligible_340b = 'Y' THEN (d.wac_price - d.price_340b) ELSE 0 END), 2) AS total_savings,
    ROUND(SUM(CASE WHEN c.eligible_340b = 'Y' THEN (d.wac_price - d.price_340b) ELSE 0 END)
          / COUNT(DISTINCT ce.entity_id), 2) AS avg_savings_per_entity
FROM claims c
JOIN covered_entities ce ON c.entity_id = ce.entity_id
JOIN drug_reference d ON c.ndc = d.ndc
GROUP BY ce.entity_type
ORDER BY total_savings DESC;
