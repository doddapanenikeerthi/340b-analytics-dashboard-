-- Q4: Ineligible Claims Billed at 340B Price (Compliance Risk)
-- Business question: Are there any claims marked ineligible for 340B that
-- were nonetheless billed at the 340B price? This is a direct HRSA audit
-- finding risk and should be near zero in a well-controlled program.

SELECT
    c.claim_id,
    c.entity_id,
    ce.entity_name,
    c.ndc,
    d.drug_name,
    c.fill_date,
    c.billed_price,
    d.price_340b,
    d.wac_price
FROM claims c
JOIN covered_entities ce ON c.entity_id = ce.entity_id
JOIN drug_reference d ON c.ndc = d.ndc
WHERE c.eligible_340b = 'N'
  AND c.billed_price <= d.price_340b
ORDER BY c.fill_date DESC;
