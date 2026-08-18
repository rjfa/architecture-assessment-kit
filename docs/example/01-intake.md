# Assessment intake

## Business outcome
- Decision this assessment must enable: approve a low-risk modernization path for OrderFlow fulfillment without committing to a rewrite.
- Deadline and consequence of delay: Q4 planning on 2026-10-15; delay extends duplicate-shipment exposure into peak season and blocks capacity planning.
- Measurable success criteria: reduce duplicate shipments by 80%, keep intake under 2 seconds during carrier outages, and enable rollback from extracted fulfillment to legacy in under 5 minutes.

## Scope
- In scope: order submission, fulfillment routing, inventory reservation interaction, carrier integration, deployment rollback constraints, and observability gaps.
- Explicitly out of scope: ERP replacement, warehouse handheld tooling, pricing rules redesign, and customer-service workflow changes.
- Stakeholders and decision owner: CTO as decision owner; fulfillment engineering lead, operations manager, support lead, and finance partner as stakeholders.

## Constraints
- Regulatory/security: order history and shipping transitions must remain auditable; PII handling must stay inside current approved data stores.
- Budget/team/skills: one platform engineer, two product engineers, and one tech lead available for 90 days; no parallel rewrite team approved.
- Availability and migration windows: peak hours require no hard downtime; high-risk migration work limited to weekday low-volume windows.

## Evidence requested
- Architecture and deployment diagrams
- Dependency inventory and ownership
- Incident/SLO history
- Delivery metrics and test reports
- Cost and capacity data

## Unknowns
| Unknown | Why it matters | Owner | Due date |
|---|---|---|---|
| Current carrier retry policy by endpoint | Changes duplicate-shipment exposure and idempotency design | Fulfillment lead | 2026-08-22 |
| True rollback time for production schema restore | Determines whether rollback claims are credible | Platform engineer | 2026-08-25 |
| Volume split by carrier during peak week | Shapes shadow-traffic cohort plan | Operations manager | 2026-08-24 |
