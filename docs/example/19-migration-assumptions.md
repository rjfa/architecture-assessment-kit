# Migration assumptions

| Assumption ID | Assumption | Why it matters | Confidence | Validation deadline | Failure impact |
|---|---|---|---|---|---|
| A-001 | Carrier retry behavior can be normalized behind one idempotent dispatch contract | Shapes RM-02 design and duplicate-rate expectations | Medium | 2026-08-22 | R1 mitigation may be incomplete |
| A-002 | Cohort-based routed migration can be rehearsed without business-hours downtime | Enables reversible RM-03 cutover | Medium | 2026-09-10 | Trigger plan may need redesign |
| A-003 | Support can adopt `PendingFulfillment` without major tooling change | Affects operational viability of R2 mitigation | Medium | 2026-09-05 | Additional support-tool work may become mandatory |

## Usage notes

- Use this document only when roadmap decisions depend on operating assumptions that are not yet proven.
- Promote failed assumptions to risks or follow-up triggers rather than hiding them locally.
