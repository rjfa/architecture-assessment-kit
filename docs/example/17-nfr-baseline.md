# NFR baseline

| NFR ID | Attribute | Current baseline | Source | Pain signal | Target direction |
|---|---|---|---|---|---|
| NFR-001 | Reliability | Duplicate shipment incidents recur during retry windows | E-001 | Refund cost and manual support correction | Reduce duplicate shipments by at least 80% |
| NFR-002 | Availability | Intake latency spikes during carrier outages | E-002 | Order intake slows and state becomes unclear | Keep intake under 2 seconds with pending state |
| NFR-003 | Reversibility | Rollback rehearsal exceeds 5 minutes and depends on SQL restore | E-004 | Structural changes are high-risk to approve | Route rollback under 5 minutes without data loss |
| NFR-004 | Observability | Correlation coverage across request, SQL, and carrier attempt is effectively absent | E-003 | Incidents are slow to diagnose | Correlated trace coverage above 95% |

## Notes

- Prefer measured baselines over estimates.
- If the baseline is unknown, record that explicitly and link the discovery task.
