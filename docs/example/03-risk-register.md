# Risk register

Score each factor 1-5. Exposure = impact x likelihood x detectability. High detectability score means the failure is hard to detect.

| ID | Risk | Evidence | Impact | Likelihood | Detectability | Exposure | Reversibility | Mitigation | Owner |
|---|---|---|---:|---:|---:|---:|---|---|---|
| R1 | Duplicate shipment after retry | Carrier retries can race with open transaction and missing idempotency keys; see [assessment.md](G:\raul\dev\architecture-assessment-kit\docs\example\assessment.md:7) | 5 | 4 | 5 | 100 | Moderate after outbox adoption | Add idempotency key, transactional outbox, and idempotent consumer before extraction | Fulfillment lead |
| R2 | Unknown order state during carrier outage | Carrier timeout keeps transaction open and no correlation ID ties request to state transition | 5 | 4 | 4 | 80 | Low in current state | Introduce explicit `PendingFulfillment` state and state-transition telemetry | Tech lead |
| R3 | Regression during module extraction | Critical fulfillment paths have only 18% characterization coverage and rollback needs database restore | 4 | 4 | 4 | 64 | Moderate with routed fallback | Build characterization and contract tests before moving traffic | Platform engineer |

## Thresholds
- 75-125: act before expansion.
- 40-74: schedule and instrument.
- 1-39: monitor or accept explicitly.
