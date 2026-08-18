# Incremental modernization roadmap

| Horizon | Outcome | Change | Entry evidence | Exit measure | Rollback | Dependencies |
|---|---|---|---|---|---|---|
| Stabilize | Make behavior observable before structural change | Add correlation IDs, structured state-transition logs, and characterization tests for the ten highest-value order paths | Risks [R1](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:5), [R2](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:5), and [R3](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:5); scenarios [QAS-01](G:\raul\dev\architecture-assessment-kit\docs\example\04-quality-attribute-scenarios.md:4) and [QAS-02](G:\raul\dev\architecture-assessment-kit\docs\example\04-quality-attribute-scenarios.md:5) | Correlated telemetry covers 95% of fulfillment transitions and characterization suite runs in CI | Disable new telemetry sinks while preserving existing behavior | Logging schema, test harness |
| Isolate | Introduce a safe seam around carrier interaction | Place carrier calls behind a port, add transactional outbox, and make consumer idempotent | Stabilize exit plus accepted [ADR-001](G:\raul\dev\architecture-assessment-kit\docs\example\adr\ADR-001-incremental-modernization.md:1) | Duplicate shipment rate reduced by 80% and pending state visible end-to-end | Route port implementation back to legacy direct call path | Outbox table, feature flags |
| Extract | Move fulfillment behind reversible routing | Extract fulfillment module, shadow traffic, compare outcomes, then migrate cohorts | Isolate exit plus routed fallback validated by [QAS-03](G:\raul\dev\architecture-assessment-kit\docs\example\04-quality-attribute-scenarios.md:6) | 2 release cycles meet SLOs with no irreversible data divergence | Flip traffic to legacy route and retain outbox audit trail | Routing seam, contract tests |
| Optimize | Reduce cost and operational friction after risk burn-down | Tune capacity, simplify support operations, and retire obsolete monolith code paths | Stable extracted fulfillment for 2 release cycles | Support ticket volume and carrier retry cost trend downward for 30 days | Pause code retirement and continue dual-run mode | Stable ownership, operational dashboard |

## Sequencing rules
- Resolve observability gaps before structural migration.
- Prefer seams and reversible routing over broad rewrites.
- Tie each increment to a risk reduction or measurable outcome.
