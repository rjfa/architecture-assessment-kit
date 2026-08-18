# ADR-001: Incremental modernization through explicit seams

- Status: Accepted
- Related risks: R1, R2, R3

## Context
OrderFlow has valuable stable behavior but unsafe coupling and weak observability.

## Decision
Add telemetry and characterization tests, isolate carrier dependencies, then extract fulfillment through feature-flagged routing.

## Alternatives
- Full rewrite: rejected because behavior and migration risk are insufficiently characterized.
- Maintain unchanged: rejected because duplicate shipment exposure is material.

## Consequences
Migration takes multiple controlled increments but each increment reduces measurable risk.

## Reversal plan
Route new operations to the legacy implementation while keeping the outbox and audit trail intact.
