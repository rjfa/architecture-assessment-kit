# Evidence register

| Evidence ID | Source artifact or system | Observation | Timestamp | Owner | Confidence | Related drivers | Related risks | Follow-up needed |
|---|---|---|---|---|---|---|---|---|
| E-001 | Fulfillment incident review and carrier retry logs | Duplicate shipment incidents correlate with retried carrier callbacks and lack of idempotency key enforcement | 2026-08-12 10:30 | Fulfillment lead | High | BD-001, BD-002 | R1 | Confirm carrier-specific retry windows before production rollout |
| E-002 | Production latency dashboard | Carrier outages cause intake latency spikes while synchronous shipment calls block request completion | 2026-08-11 14:15 | Platform engineer | High | BD-001, BD-003 | R2 | Add segmented view by carrier and order cohort |
| E-003 | Architecture walkthrough with state-transition samples | No shared correlation ID links request, SQL reservation, and carrier attempt for the same order | 2026-08-13 09:00 | Tech lead | Medium | BD-001, BD-003, BD-004 | R2 | Verify field propagation path in production logs |
| E-004 | Release rehearsal notes | Current rollback requires application redeploy and SQL restore, exceeding the desired 5-minute recovery window | 2026-08-14 16:45 | Platform engineer | High | BD-002, BD-004 | R3 | Rehearse routed rollback once seam exists |
| E-005 | Characterization test inventory | Only 18% of critical fulfillment paths are covered by characterization tests | 2026-08-15 11:20 | QA lead | High | BD-001, BD-004 | R3 | Identify top ten critical paths for initial coverage tranche |
| E-006 | Support escalation summaries | Support cannot reliably tell whether orders are pending, stuck, or duplicated during carrier instability | 2026-08-10 08:50 | Support lead | Medium | BD-002, BD-003 | R1, R2 | Validate proposed `PendingFulfillment` semantics with operations |
