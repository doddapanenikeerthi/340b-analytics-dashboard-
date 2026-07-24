-- Q3: Replenishment Lag Analysis
-- Business question: How long does it take, on average, for a covered
-- entity to replenish 340B inventory after a triggering claim? Long lags
-- can signal inventory control issues or missed replenishment cycles.

SELECT
    ce.entity_id,
    ce.entity_name,
    ROUND(AVG(ro.lag_days_from_trigger_claim), 1) AS avg_lag_days,
    MIN(ro.lag_days_from_trigger_claim) AS min_lag_days,
    MAX(ro.lag_days_from_trigger_claim) AS max_lag_days,
    COUNT(*) AS total_orders
FROM replenishment_orders ro
JOIN covered_entities ce ON ro.entity_id = ce.entity_id
GROUP BY ce.entity_id, ce.entity_name
ORDER BY avg_lag_days DESC;
