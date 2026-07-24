-- Q2: Duplicate Discount Risk (HRSA compliance flag)
-- Business question: Which claims are flagged by the TPA as potential
-- duplicate discounts -- i.e., claims that may have already received a
-- Medicaid rebate AND a 340B discount? This is a core HRSA audit exposure.

SELECT
    sbf.claim_id,
    sbf.tpa_name,
    sbf.match_status,
    c.entity_id,
    ce.entity_name,
    c.ndc,
    d.drug_name,
    c.fill_date,
    c.billed_price
FROM split_billing_flags sbf
JOIN claims c ON sbf.claim_id = c.claim_id
JOIN covered_entities ce ON c.entity_id = ce.entity_id
JOIN drug_reference d ON c.ndc = d.ndc
WHERE sbf.match_status = 'Duplicate Discount Risk'
ORDER BY c.fill_date DESC;
