# Stakeholder interview notes

## Session metadata

- Interview ID: INT-001
- Date: 2026-08-09
- Interviewer: Tech lead
- Stakeholder: Operations manager
- Role: Fulfillment operations

## Questions and answers

| Question | Answer | Confidence | Follow-up |
|---|---|---|---|
| What hurts most during carrier instability | Support cannot distinguish delayed orders from duplicated shipments quickly enough | High | Link to [E-006](G:\raul\dev\architecture-assessment-kit\docs\example\10-evidence-register.md:9) |
| What rollout shape is acceptable | Start with one carrier cohort and preserve rollback to legacy path inside one shift | Medium | Validate with platform rehearsal plan |
| What would block approval | Any plan that requires outage during business hours or loses auditability | High | Carry into [12-assessment-playbook.md](G:\raul\dev\architecture-assessment-kit\docs\example\12-assessment-playbook.md:1) |

## Signals captured

- Business pain points: duplicate shipments create refund cost and trust erosion before peak season.
- Operational pain points: support cannot trust state during outages and rollback rehearsals are too slow.
- Decision constraints: no business-hours downtime and no loss of order-transition audit trail.
- Risks or unknowns surfaced: carrier-specific retry semantics still need confirmation.

## Trace links

- Related business drivers: BD-002, BD-003, BD-004
- Related risks: R1, R2, R3
- Related evidence or assumptions: E-006, A-001
