-- Q6: Split-Billing TPA Match Status Summary
-- Business question: Across our third-party administrators (Verity,
-- Sentry, Macro Helix, Kalderos), what's the breakdown of matched vs.
-- unmatched vs. at-risk claims? Helps identify which TPA relationship
-- needs process attention.

SELECT
    tpa_name,
    match_status,
    COUNT(*) AS claim_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY tpa_name), 1) AS pct_of_tpa_volume
FROM split_billing_flags
GROUP BY tpa_name, match_status
ORDER BY tpa_name, claim_count DESC;
