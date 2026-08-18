# Glossary and identifier conventions

## Identifier conventions

| Prefix | Meaning | Example |
|---|---|---|
| `BD-` | Business driver or decision intent | `BD-001` |
| `E-` | Evidence item | `E-003` |
| `R-` or `R` | Risk item | `R1` |
| `QAS-` | Quality-attribute scenario | `QAS-02` |
| `ADR-` | Architecture decision record | `ADR-001` |
| `RM-` | Roadmap item or horizon row | `RM-03` |
| `DEC-` | Decision log entry | `DEC-001` |
| `TD-` | Technical debt item | `TD-004` |
| `U-` | Unknown or assumption under investigation | `U-002` |

## Traceability rules

- Every recommendation should map to at least one `BD-` and one `E-` item.
- Every `ADR-` should reference the `R` items it changes or accepts.
- Every `RM-` item should name the risks or scenarios it is intended to improve.
- Every `TD-` item should map to at least one operational signal or explicit risk.

## Unknown handling

- Unknowns start as `U-` items in intake or discovery notes.
- A `U-` item graduates into `E-` when it is verified with a source and timestamp.
- A `U-` item becomes a risk when the uncertainty itself creates material exposure.
- A `U-` item can be accepted temporarily only when the decision owner records the review trigger explicitly.

## Glossary

- `Reversibility`: the ability to undo or reroute a change without unacceptable data loss or outage.
- `Detectability`: how hard it is to notice the failure before it causes material damage. Higher score means harder to detect.
- `Characterization test`: a test that captures current behavior to reduce regression risk before structural change.
- `Seam`: a controllable boundary where behavior can be redirected, substituted, or observed with limited blast radius.
