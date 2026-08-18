# Technical debt map

| Debt ID | Item | Business impact | Operational signal | Change friction | Risk link | Recommended treatment |
|---|---|---|---|---|---|---|
| TD-001 | Carrier calls inside open SQL transaction | Duplicate shipments and unclear order state during outages | Long-running transactions and support escalations | High because logic is embedded in monolith transaction flow | [R1](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:5), [R2](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:5) | Remediate |
| TD-002 | No correlation ID across request, SQL, and carrier attempt | Slow incident triage and weak rollback confidence | Missing trace joins across app, DB, and outbound calls | Medium | [R2](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:5) | Contain then remediate |
| TD-003 | Release rollback requires database restore | High change risk and delayed recovery from bad release | Rollback rehearsals exceed acceptable recovery window | High | [R3](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:5) | Replace |
| TD-004 | Fulfillment rules tightly coupled to monolith module boundaries | Makes extraction slower and increases regression risk | Frequent multi-team edits in the same deployment unit | Medium | [R3](G:\raul\dev\architecture-assessment-kit\docs\example\03-risk-register.md:5) | Contain |
