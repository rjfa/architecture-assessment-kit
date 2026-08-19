# Measurement plan

| Metric ID | Metric | Why it matters | Baseline | Target | Source | Review cadence | Owner |
|---|---|---|---|---|---|---|---|
| M-001 | Duplicate shipment rate | Validates reduction of risk R1 | Current incident baseline from E-001 | 80% reduction after RM-02 | Carrier and order-event telemetry | Weekly during RM-02 | Fulfillment lead |
| M-002 | Intake p95 during carrier outage | Validates QAS-02 and NFR-002 | Outage spike pattern from E-002 | Under 2 seconds | API latency dashboard | Daily during outage drills | Platform engineer |
| M-003 | Routed rollback duration | Validates RM-03 reversibility | Current rollback slower than 5 minutes from E-004 | Under 5 minutes | Rehearsal runbook timing | Each rehearsal | Platform engineer |
| M-004 | Correlated transition coverage | Validates observability improvement | Effectively absent today from E-003 | Above 95% | Trace pipeline and state logs | Weekly during RM-01 | Tech lead |

## Rules

- Every target should support either a risk reduction, a quality scenario, or a roadmap exit measure.
- If a metric is not yet instrumented, record the instrumentation step explicitly instead of omitting it.
