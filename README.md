# Architecture Assessment Kit

Production-oriented templates and a completed example for architecture assessments, risk analysis, ADRs, and incremental modernization roadmaps.

## What this proves

- Business-first technical assessment
- Explicit quality attributes and risk scoring
- Traceable decisions and reversible modernization
- A consulting deliverable a CTO can review before engagement

## Start here

1. Copy `templates/` into an assessment workspace.
2. Complete intake and system inventory.
3. Score risks using `impact x likelihood x detectability`.
4. Define measurable quality-attribute scenarios.
5. Record decisions as ADRs and sequence the roadmap.

See the complete fictional case in [`docs/example`](docs/example/assessment.md).

## Repository map

```text
templates/           Reusable consulting templates
docs/example/        Completed fictional OrderFlow assessment
docs/example/adr/    Decisions from the example
CONTRIBUTING.md      Quality and contribution rules
```

## Validation

```bash
./validate.sh
```

```powershell
pwsh ./validate.ps1
```

`validate.sh` is the unified entry point on Unix-like environments and forwards to `pwsh`.
Use `pwsh ./validate.ps1` on Windows or anywhere you want to invoke the validator directly.

The validator reports checks by section instead of returning a single generic success line. Current sections cover structure, required document markers, content hygiene, references, and lightweight semantic traceability between the example assessment and its ADR.

No client code, names, schemas, or proprietary rules are included.

## License

MIT. Use the templates; preserve attribution where required.
