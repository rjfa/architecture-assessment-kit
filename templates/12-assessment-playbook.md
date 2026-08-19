# Assessment playbook

## Purpose

Define how to run an architecture assessment from intake to decision review with explicit entry criteria, exit criteria, and review triggers.

## Roles

| Role | Responsibility |
|---|---|
| Decision owner | Approves scope, accepts risks, and signs off on the recommendation |
| Assessor or tech lead | Synthesizes evidence, maintains artifacts, and states unknowns explicitly |
| Domain owner | Provides source-of-truth operational and system context |
| Platform or delivery owner | Confirms deployment, rollback, and observability constraints |

## Phases

| Phase | Objective | Required inputs | Exit criteria | Primary outputs |
|---|---|---|---|---|
| Intake | Frame the decision in business terms | Sponsor request, decision owner, constraints | Scope, success criteria, and unknowns are explicit | Intake |
| State | Describe the current system and risk posture | Architecture context, owners, incident history | Core system picture and hotspots are documented | System inventory, risk register, quality scenarios |
| Memory | Make recommendations traceable | Evidence, risks, scenarios, candidate decisions | Recommendation traces to business drivers and evidence | Traceability matrix, evidence register, glossary |
| Trigger | Define how work proceeds and how decisions re-open | Draft recommendation, roadmap, ADRs | Review triggers and evidence thresholds are explicit | Playbook, decision log, post-decision review |

## Minimum evidence threshold

Do not issue a modernization recommendation until all of the following are true:

1. At least one business decision owner is named.
2. At least three high-confidence evidence items exist or the evidence gap is explicitly accepted.
3. Material risks have named owners and mitigation direction.
4. At least one measurable quality-attribute scenario exists for each material recommendation.
5. A rollback or reversal path is stated for structural changes.

## Review triggers

- Re-open the recommendation if a top risk materially increases after new evidence arrives.
- Re-open the recommendation if rollback assumptions are falsified in rehearsal.
- Re-open the recommendation if the chosen roadmap increment fails its exit measure.
- Stop the assessment if critical unknowns remain unresolved and the decision would otherwise be opinion-driven.

## Assessment stop rule

Pause or stop the assessment when:

- the decision owner is unknown,
- evidence remains mostly low confidence,
- core system ownership is disputed,
- or the recommendation would require broad structural change without a reversible path.
