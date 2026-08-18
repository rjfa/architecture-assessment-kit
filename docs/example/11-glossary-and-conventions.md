# Glossary and identifier conventions

## Identifier conventions used in this example

| Prefix | Meaning | Example |
|---|---|---|
| `BD-` | Business driver or decision intent | `BD-001` |
| `E-` | Evidence item | `E-003` |
| `R` | Risk item | `R2` |
| `QAS-` | Quality-attribute scenario | `QAS-02` |
| `ADR-` | Architecture decision record | `ADR-001` |
| `RM-` | Roadmap item or horizon row | `RM-03` |
| `DEC-` | Decision log entry | `DEC-001` |
| `TD-` | Technical debt item | `TD-004` |
| `U-` | Unknown under investigation | `U-002` |

## Traceability rules applied here

- Every recommendation in the example traces to at least one `BD-` and one `E-` item through [09-traceability-matrix.md](G:\raul\dev\architecture-assessment-kit\docs\example\09-traceability-matrix.md:1).
- `ADR-001` names the risks it addresses and is linked from the executive assessment and the decision log.
- Each roadmap row in [06-modernization-roadmap.md](G:\raul\dev\architecture-assessment-kit\docs\example\06-modernization-roadmap.md:1) uses an `RM-` identifier so downstream artifacts can refer to it directly.
- Debt items in [08-technical-debt-map.md](G:\raul\dev\architecture-assessment-kit\docs\example\08-technical-debt-map.md:1) use `TD-` identifiers and link back to explicit risks.

## Unknown handling

- Unknowns start in [01-intake.md](G:\raul\dev\architecture-assessment-kit\docs\example\01-intake.md:1) and should be treated as `U-` items even if the table does not yet carry an explicit ID column.
- When an unknown is verified with a source, owner, and timestamp, it should graduate into the evidence register as an `E-` item.
- When uncertainty itself creates material exposure, it should be elevated into the risk register instead of being left as implicit context.

## Glossary

- `Reversibility`: the ability to undo or reroute a change without unacceptable data loss or outage.
- `Detectability`: how hard it is to notice the failure before it causes material damage. Higher score means harder to detect.
- `Characterization test`: a test that captures current behavior to reduce regression risk before structural change.
- `Seam`: a controllable boundary where behavior can be redirected, substituted, or observed with limited blast radius.
