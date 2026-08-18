# Master Mitigation Checklist

- Date created: 2026-08-18
- Source audit: [2026-08-18-architecture-kit-audit.md](G:\raul\dev\architecture-assessment-kit\docs\audit\2026-08-18-architecture-kit-audit.md:1)
- Objective: close the identified architecture-kit gaps through iterative, evidence-based improvements
- Guiding hypothesis: if each iteration closes one explicit gap with a measurable repository outcome, the kit should become more repeatable without accumulating process debt

## Operating rules

- Keep each iteration small and falsifiable.
- Attach every change to a concrete repository artifact.
- Prefer refactoring and explicit contracts over adding parallel documents with overlapping responsibility.
- Validate each iteration with the smallest material proof possible.
- Preserve the current business-first and reversible-modernization posture.

## Phase 1: Detection

### Validation hardening

- [x] Replace or complement [validate.sh](G:\raul\dev\architecture-assessment-kit\validate.sh:1) with a cross-platform validator.
- [x] Verify required files exist for the canonical kit structure.
- [x] Verify every required template contains mandatory sections.
- [x] Verify the example references at least one ADR and a roadmap recommendation.
- [x] Verify no unresolved placeholders exist across `docs/` and `templates/`.
- [x] Verify links between example files resolve correctly.
- [x] Verify encoding consistency to avoid malformed characters in rendered Markdown.
- [x] Decide whether validation should live in PowerShell, a portable script, or both.
- [x] Report validation output by named section instead of returning a single generic success line.
- [x] Add lightweight semantic traceability checks between the example assessment and ADR.
- [x] Extend validation to cover traceability matrix, evidence register, glossary conventions, and cross-artifact ID linkage.

### Acceptance criteria

- [ ] Validation runs successfully in the target contributor environments.
- [x] Validation fails on missing required sections, broken links, or placeholders.
- [x] Validation reports what it checked in a way a contributor can inspect quickly.

## Phase 2: State

### Canonical repository output

- [x] Define what a "complete assessment package" means for this repository.
- [x] Create a single canonical output structure under `docs/example/` or equivalent.
- [x] Expand the example so it uses every core template, not only the assessment narrative and one ADR.
- [x] Ensure the example includes intake, inventory, risks, quality scenarios, roadmap, decision log, and debt map.
- [x] Add a clear table of contents or index for the example package.

### Acceptance criteria

- [x] A new contributor can inspect one example and understand the full expected output set.
- [x] Every core template has one completed example instance.

## Phase 3: Memory

### Traceability and evidence

- [x] Add a `traceability-matrix` template linking business drivers, evidence, risks, scenarios, ADRs, roadmap items, and debt items.
- [x] Add an `evidence-register` template with source, timestamp, owner, confidence, and open follow-up fields.
- [x] Add repository conventions for identifiers such as risk IDs, ADR IDs, scenario IDs, and roadmap item IDs.
- [x] Add a glossary for scoring, reversibility, criticality, and assessment terms.
- [x] Define how unknowns graduate into either evidence, accepted assumptions, or explicit risks.

### Acceptance criteria

- [x] A reviewer can trace any recommendation back to evidence and business intent.
- [x] Identifiers are consistent across all templates and examples.

## Phase 4: Trigger

### Assessment workflow and review loop

- [ ] Add an `assessment-playbook` documenting phases, roles, inputs, outputs, and exit criteria.
- [ ] Define the minimum evidence threshold required before issuing a modernization recommendation.
- [ ] Add a `post-decision-review` or `implementation-review` template.
- [ ] Define review triggers for ADR re-evaluation and roadmap checkpointing.
- [ ] Add explicit guidance for when to stop the assessment because uncertainty remains too high.

### Acceptance criteria

- [ ] Two different assessors can follow the same process with low ambiguity.
- [ ] Material decisions include review triggers and measurable follow-up signals.

## Phase 5: Input

### New input artifacts

- [ ] Add a stakeholder interview or discovery-notes template.
- [ ] Add a current-state architecture template.
- [ ] Add a target-state architecture template.
- [ ] Add an NFR baseline template.
- [ ] Add a measurement-plan template tied to modernization outcomes.
- [ ] Consider adding a migration assumptions template if roadmap decisions depend on unstated operating constraints.

### Acceptance criteria

- [ ] Early discovery inputs can be captured without improvising ad hoc documents.
- [ ] Target-state recommendations are explicitly tied to measurable architecture outcomes.

## Existing pieces to preserve

- [ ] Keep the business-first intake structure in [templates/01-intake.md](G:\raul\dev\architecture-assessment-kit\templates\01-intake.md:1).
- [ ] Keep the component and hotspot framing in [templates/02-system-inventory.md](G:\raul\dev\architecture-assessment-kit\templates\02-system-inventory.md:1).
- [ ] Keep the risk scoring approach in [templates/03-risk-register.md](G:\raul\dev\architecture-assessment-kit\templates\03-risk-register.md:1).
- [ ] Keep measurable quality scenarios in [templates/04-quality-attribute-scenarios.md](G:\raul\dev\architecture-assessment-kit\templates\04-quality-attribute-scenarios.md:1).
- [ ] Keep reversal planning in [templates/05-adr.md](G:\raul\dev\architecture-assessment-kit\templates\05-adr.md:1).
- [ ] Keep the incremental sequencing rules in [templates/06-modernization-roadmap.md](G:\raul\dev\architecture-assessment-kit\templates\06-modernization-roadmap.md:1).

## Risks to watch while iterating

- [ ] Avoid adding duplicate templates that split the same responsibility across multiple files.
- [ ] Avoid overfitting the kit to a single consulting style or one fictional case.
- [ ] Avoid adding governance ceremony that is not validated by a real assessment need.
- [ ] Avoid hiding gaps with vague prose when an explicit contract or field is needed.
- [ ] Avoid mixing higher-layer opinions when the actual gap is a local repository contract.

## Iteration log

| Iteration | Date | Hypothesis | Change | Material validation | Result | Next step |
|---|---|---|---|---|---|---|
| 0 | 2026-08-18 | The repository is useful but incomplete as a repeatable assessment system | Created audit and mitigation checklist | Audit saved in `docs/audit/` | Baseline established | Start with detection hardening |
| 1 | 2026-08-18 | A portable validator with structural checks will improve trust in the kit without adding process debt | Added `validate.ps1`, strengthened validation rules, documented Windows usage, and fixed markdown encoding drift in core files | `powershell -ExecutionPolicy Bypass -File .\\validate.ps1` passed on 2026-08-18 | Completed | Decide whether to keep `validate.sh` as a thin wrapper or converge on a single cross-platform validator |
| 2 | 2026-08-18 | Sectioned validation output and lightweight semantic checks will make the validator more useful without turning it into a heavy governance tool | Refactored `validate.ps1` to report checks by section, added semantic linkage checks between the example assessment and ADR, and cleaned remaining audit-doc encoding drift | `powershell -ExecutionPolicy Bypass -File .\\validate.ps1` passed on 2026-08-18 and reported 20 checks across 5 sections | Completed | Decide whether to extend semantic checks to future example artifacts |
| 3 | 2026-08-18 | Completing the example package before expanding validation will reduce overfitting and make later traceability checks anchor to real artifacts | Added the missing example documents for intake, inventory, risk register, quality scenarios, roadmap, decision log, technical debt map, and a package index; linked them from the executive assessment | `powershell -ExecutionPolicy Bypass -File .\\validate.ps1` passed on 2026-08-18 and `docs/example/` now contains one completed instance of each core template | Completed | Move to Phase 3 and add a formal traceability matrix plus evidence register |
| 4 | 2026-08-18 | Explicit memory artifacts will let contributors trace recommendations without relying on tacit context | Added templates and example instances for a traceability matrix, evidence register, and glossary with identifier conventions; updated roadmap, decision log, debt map, and assessment links to use explicit IDs | `powershell -ExecutionPolicy Bypass -File .\\validate.ps1` passed on 2026-08-18; new `Memory` artifacts were added to `templates/` and `docs/example/` with no placeholders or encoding drift | Completed | Extend the validator to verify the new memory artifacts once their structure is considered stable |
| 5 | 2026-08-18 | Once memory artifacts stabilize, detection should verify their structure and cross-artifact link integrity directly | Extended `validate.ps1` to cover the new templates and example documents, and added ID-linkage checks across traceability matrix, evidence register, roadmap, decision log, debt map, and glossary conventions | `powershell -ExecutionPolicy Bypass -File .\\validate.ps1` passed on 2026-08-18 and reported 44 checks across 6 sections | Completed | Move to Phase 4 or decide whether to separate staged changes by phase before continuing |
