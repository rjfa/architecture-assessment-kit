# Traceability matrix

| Driver ID | Driver / Intent | Evidence IDs | Risk IDs | Scenario IDs | ADRs | Roadmap items | Decision log | Debt items | Notes |
|---|---|---|---|---|---|---|---|---|---|
| BD-001 | Approve a low-risk fulfillment modernization path instead of a rewrite | E-001, E-002, E-003, E-005 | R1, R2, R3 | QAS-01, QAS-02, QAS-03 | ADR-001 | RM-01, RM-02, RM-03 | DEC-001 | TD-001, TD-002, TD-003, TD-004 | Primary business decision defined in [01-intake.md](G:\raul\dev\architecture-assessment-kit\docs\example\01-intake.md:1) |
| BD-002 | Reduce duplicate shipments before peak season | E-001, E-004, E-006 | R1 | QAS-01 | ADR-001 | RM-01, RM-02 | DEC-001 | TD-001 | Directly tied to pre-extraction idempotency and outbox work |
| BD-003 | Keep intake under 2 seconds during carrier outages | E-002, E-003, E-006 | R2 | QAS-02 | ADR-001 | RM-01, RM-02 | DEC-001 | TD-001, TD-002 | Requires explicit pending state and correlation |
| BD-004 | Preserve a reversible rollback path during extraction | E-003, E-004, E-005 | R3 | QAS-03 | ADR-001 | RM-01, RM-03 | DEC-001 | TD-003, TD-004 | Reversibility remains a release gate until extracted path proves stable |
