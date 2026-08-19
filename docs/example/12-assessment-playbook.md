# Assessment playbook

## Purpose

Run the OrderFlow assessment in a way that keeps the recommendation anchored to evidence, reversibility, and explicit review triggers.

## Roles

| Role | Responsibility |
|---|---|
| CTO | Decision owner for modernization approval and risk acceptance |
| Tech lead | Maintains assessment package and synthesizes recommendation |
| Fulfillment lead | Owns operational truth for carrier behavior and shipment flow |
| Platform engineer | Confirms deployment, rollback, and observability constraints |
| Support lead | Provides customer-impact signals and validates pending-state semantics |

## Phases

| Phase | Objective | Required inputs | Exit criteria | Primary outputs |
|---|---|---|---|---|
| Intake | Clarify what decision the assessment must enable | Sponsor request, stakeholder list, migration constraints | [01-intake.md](G:\raul\dev\architecture-assessment-kit\docs\example\01-intake.md:1) names the decision owner, success criteria, and unknowns | Intake |
| State | Describe the current fulfillment system and top risks | Diagrams, incidents, deployments, hotspot review | [02-system-inventory.md](G:\raul\dev\architecture-assessment-kit\docs\example\02-system-inventory.md:1), [03-risk-register.md](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:1), and [04-quality-attribute-scenarios.md](G:\raul\dev\architecture-assessment-kit\docs\example\04-quality-attribute-scenarios.md:1) are complete | System inventory, risks, scenarios |
| Memory | Trace the recommendation back to evidence and intent | Evidence, drivers, risks, ADR candidate | [09-traceability-matrix.md](G:\raul\dev\architecture-assessment-kit\docs\example\09-traceability-matrix.md:1) and [10-evidence-register.md](G:\raul\dev\architecture-assessment-kit\docs\example\10-evidence-register.md:1) connect the recommendation to real signals | Traceability matrix, evidence register |
| Trigger | Define how work proceeds and how the decision can re-open | ADR, roadmap, review conditions | [07-decision-log.md](G:\raul\dev\architecture-assessment-kit\docs\example\07-decision-log.md:1) and [13-post-decision-review.md](G:\raul\dev\architecture-assessment-kit\docs\example\13-post-decision-review.md:1) define explicit triggers and follow-up signals | Decision log, review loop |

## Minimum evidence threshold

Do not recommend incremental extraction unless:

1. The decision owner is named and accepts reversible migration as a constraint.
2. At least three evidence items are high confidence: currently [E-001](G:\raul\dev\architecture-assessment-kit\docs\example\10-evidence-register.md:4), [E-002](G:\raul\dev\architecture-assessment-kit\docs\example\10-evidence-register.md:5), [E-004](G:\raul\dev\architecture-assessment-kit\docs\example\10-evidence-register.md:7), and [E-005](G:\raul\dev\architecture-assessment-kit\docs\example\10-evidence-register.md:8) satisfy this threshold.
3. Each material risk [R1](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:5), [R2](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:5), and [R3](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:5) has an owner and mitigation direction.
4. Scenarios [QAS-01](G:\raul\dev\architecture-assessment-kit\docs\example\04-quality-attribute-scenarios.md:4), [QAS-02](G:\raul\dev\architecture-assessment-kit\docs\example\04-quality-attribute-scenarios.md:5), and [QAS-03](G:\raul\dev\architecture-assessment-kit\docs\example\04-quality-attribute-scenarios.md:6) are measurable.
5. The roadmap includes a reversal path through [RM-02](G:\raul\dev\architecture-assessment-kit\docs\example\06-modernization-roadmap.md:5) and [RM-03](G:\raul\dev\architecture-assessment-kit\docs\example\06-modernization-roadmap.md:6).

## Review triggers

- Re-open [DEC-001](G:\raul\dev\architecture-assessment-kit\docs\example\07-decision-log.md:3) if duplicate shipments do not materially improve after [RM-02](G:\raul\dev\architecture-assessment-kit\docs\example\06-modernization-roadmap.md:5).
- Re-open [ADR-001](G:\raul\dev\architecture-assessment-kit\docs\example\adr\ADR-001-incremental-modernization.md:1) if the routed rollback rehearsal for [RM-03](G:\raul\dev\architecture-assessment-kit\docs\example\06-modernization-roadmap.md:6) exceeds 5 minutes.
- Stop the assessment if carrier retry semantics remain unknown past 2026-08-22 because [R1](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:5) would remain under-characterized.

## Assessment stop rule

Pause the recommendation if evidence confidence drops below the current threshold, the rollback path cannot be rehearsed, or the decision owner asks for a rewrite without new evidence that changes the current risk picture.
