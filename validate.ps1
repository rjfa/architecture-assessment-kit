Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$script:CheckResults = New-Object System.Collections.Generic.List[object]

function Add-CheckResult {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Section,
    [Parameter(Mandatory = $true)]
    [string]$Check,
    [Parameter(Mandatory = $true)]
    [string]$Details
  )

  $script:CheckResults.Add([pscustomobject]@{
    Section = $Section
    Check = $Check
    Details = $Details
  }) | Out-Null
}

function Assert-FileExists {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Path
  )

  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    throw "Missing required file: $Path"
  }
}

function Assert-Contains {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [Parameter(Mandatory = $true)]
    [string[]]$Patterns
  )

  $content = Get-Content -LiteralPath $Path -Raw
  foreach ($pattern in $Patterns) {
    if ($content -notmatch [regex]::Escape($pattern)) {
      throw "Missing required content in ${Path}: $pattern"
    }
  }
}

function Assert-Matches {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Content,
    [Parameter(Mandatory = $true)]
    [string]$Pattern,
    [Parameter(Mandatory = $true)]
    [string]$FailureMessage
  )

  if ($Content -notmatch $Pattern) {
    throw $FailureMessage
  }
}

function Assert-NoPatternMatches {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Paths,
    [Parameter(Mandatory = $true)]
    [string]$Pattern,
    [Parameter(Mandatory = $true)]
    [string]$FailureMessage
  )

  $matches = Select-String -Path $Paths -Pattern $Pattern
  if ($matches) {
    $details = ($matches | ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" }) -join [Environment]::NewLine
    throw "$FailureMessage`n$details"
  }
}

function Assert-RelativeMarkdownLinksExist {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Path
  )

  $content = Get-Content -LiteralPath $Path -Raw
  $directory = Split-Path -Parent $Path
  if ([string]::IsNullOrWhiteSpace($directory)) {
    $directory = "."
  }

  $matches = [regex]::Matches($content, '\[[^\]]+\]\((?!https?://|mailto:|#)([^)]+)\)')
  foreach ($match in $matches) {
    $relativeTarget = $match.Groups[1].Value
    if ($relativeTarget -match '^[A-Za-z]:\\') {
      continue
    }

    $normalizedTarget = ($relativeTarget -split '#')[0]
    if ([string]::IsNullOrWhiteSpace($normalizedTarget)) {
      continue
    }

    $targetPath = Join-Path -Path $directory -ChildPath $normalizedTarget
    if (-not (Test-Path -LiteralPath $targetPath)) {
      throw "Broken relative markdown link in ${Path}: $relativeTarget"
    }
  }
}

function Get-FileContent {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Path
  )

  return Get-Content -LiteralPath $Path -Raw
}

function Get-Matches {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Content,
    [Parameter(Mandatory = $true)]
    [string]$Pattern
  )

  return [regex]::Matches($Content, $Pattern)
}

function Write-ValidationReport {
  $sections = $script:CheckResults | Group-Object -Property Section

  Write-Host "Architecture Assessment Kit validation report"
  Write-Host ""

  foreach ($section in $sections) {
    Write-Host ("[{0}]" -f $section.Name)
    foreach ($result in $section.Group) {
      Write-Host ("  OK - {0}: {1}" -f $result.Check, $result.Details)
    }
    Write-Host ("  Summary: {0} checks passed" -f $section.Count)
    Write-Host ""
  }

  Write-Host ("Validation passed: {0} checks across {1} sections" -f $script:CheckResults.Count, $sections.Count)
}

$requiredFiles = @(
  "README.md",
  "CONTRIBUTING.md",
  "validate.sh",
  "validate.ps1",
  "templates/01-intake.md",
  "templates/02-system-inventory.md",
  "templates/03-risk-register.md",
  "templates/04-quality-attribute-scenarios.md",
  "templates/05-adr.md",
  "templates/06-modernization-roadmap.md",
  "templates/07-decision-log.md",
  "templates/08-technical-debt-map.md",
  "templates/09-traceability-matrix.md",
  "templates/10-evidence-register.md",
  "templates/11-glossary-and-conventions.md",
  "templates/12-assessment-playbook.md",
  "templates/13-post-decision-review.md",
  "docs/example/README.md",
  "docs/example/assessment.md",
  "docs/example/06-modernization-roadmap.md",
  "docs/example/07-decision-log.md",
  "docs/example/08-technical-debt-map.md",
  "docs/example/09-traceability-matrix.md",
  "docs/example/10-evidence-register.md",
  "docs/example/11-glossary-and-conventions.md",
  "docs/example/12-assessment-playbook.md",
  "docs/example/13-post-decision-review.md",
  "docs/example/adr/ADR-001-incremental-modernization.md"
)

foreach ($requiredFile in $requiredFiles) {
  Assert-FileExists -Path $requiredFile
}
Add-CheckResult -Section "Structure" -Check "Required files" -Details ("{0} required files are present" -f $requiredFiles.Count)

$requiredContent = @{
  "README.md" = @(
    "# Architecture Assessment Kit",
    "## What this proves",
    "## Start here",
    "## Validation"
  )
  "templates/01-intake.md" = @(
    "# Assessment intake",
    "## Business outcome",
    "## Scope",
    "## Constraints",
    "## Unknowns"
  )
  "templates/02-system-inventory.md" = @(
    "# System inventory",
    "## Context boundaries",
    "## Hotspots"
  )
  "templates/03-risk-register.md" = @(
    "# Risk register",
    "## Thresholds"
  )
  "templates/04-quality-attribute-scenarios.md" = @(
    "# Quality-attribute scenarios"
  )
  "templates/05-adr.md" = @(
    "# ADR-NNN: Decision title",
    "## Context",
    "## Decision",
    "## Consequences",
    "## Reversal plan"
  )
  "templates/06-modernization-roadmap.md" = @(
    "# Incremental modernization roadmap",
    "## Sequencing rules",
    "| RM-01 | Stabilize |",
    "| RM-02 | Isolate |",
    "| RM-03 | Extract |",
    "| RM-04 | Optimize |"
  )
  "templates/07-decision-log.md" = @(
    "# Decision log",
    "Decision ID"
  )
  "templates/08-technical-debt-map.md" = @(
    "# Technical debt map",
    "Debt ID"
  )
  "templates/09-traceability-matrix.md" = @(
    "# Traceability matrix",
    "## Usage notes"
  )
  "templates/10-evidence-register.md" = @(
    "# Evidence register",
    "## Confidence guide",
    "## Follow-up rule"
  )
  "templates/11-glossary-and-conventions.md" = @(
    "# Glossary and identifier conventions",
    "## Identifier conventions",
    "## Traceability rules",
    "## Unknown handling",
    "## Glossary"
  )
  "templates/12-assessment-playbook.md" = @(
    "# Assessment playbook",
    "## Purpose",
    "## Roles",
    "## Phases",
    "## Minimum evidence threshold",
    "## Review triggers",
    "## Assessment stop rule"
  )
  "templates/13-post-decision-review.md" = @(
    "# Post-decision review",
    "## Decision summary",
    "## Expected trigger",
    "## Observed outcome",
    "## Decision disposition",
    "## Follow-up actions"
  )
  "docs/example/README.md" = @(
    "# OrderFlow example package",
    "## Complete package definition",
    "## Package index",
    "## Reading order"
  )
  "docs/example/06-modernization-roadmap.md" = @(
    "# Incremental modernization roadmap",
    "RM-01",
    "RM-02",
    "RM-03",
    "RM-04"
  )
  "docs/example/07-decision-log.md" = @(
    "# Decision log",
    "DEC-001"
  )
  "docs/example/08-technical-debt-map.md" = @(
    "# Technical debt map",
    "TD-001",
    "TD-004"
  )
  "docs/example/09-traceability-matrix.md" = @(
    "# Traceability matrix",
    "BD-001",
    "ADR-001",
    "DEC-001"
  )
  "docs/example/10-evidence-register.md" = @(
    "# Evidence register",
    "E-001",
    "E-006"
  )
  "docs/example/11-glossary-and-conventions.md" = @(
    "# Glossary and identifier conventions",
    "BD-",
    "E-",
    "RM-",
    "TD-"
  )
  "docs/example/12-assessment-playbook.md" = @(
    "# Assessment playbook",
    "## Minimum evidence threshold",
    "## Review triggers",
    "DEC-001",
    "RM-02",
    "RM-03"
  )
  "docs/example/13-post-decision-review.md" = @(
    "# Post-decision review",
    "Decision ID: DEC-001",
    "ADR-001",
    "RM-02",
    "## Follow-up actions"
  )
  "docs/example/assessment.md" = @(
    "# OrderFlow assessment",
    "## Executive finding",
    "## Evidence",
    "## Risks",
    "## Quality scenarios",
    "## Recommendation",
    "## Decision",
    "ADR-001"
  )
  "docs/example/adr/ADR-001-incremental-modernization.md" = @(
    "# ADR-001:",
    "- Status:",
    "## Context",
    "## Decision",
    "## Consequences",
    "## Reversal plan"
  )
}

foreach ($entry in $requiredContent.GetEnumerator()) {
  Assert-Contains -Path $entry.Key -Patterns $entry.Value
  Add-CheckResult -Section "Required sections" -Check $entry.Key -Details ("Validated {0} required markers" -f $entry.Value.Count)
}

Assert-NoPatternMatches `
  -Paths @("docs/example/*.md", "docs/example/adr/*.md", "templates/*.md") `
  -Pattern '\b(TODO|TBD)\b' `
  -FailureMessage "Unresolved placeholder found in repository content."
Add-CheckResult -Section "Content hygiene" -Check "Placeholders" -Details "No TODO or TBD markers remain in templates or example content"

$suspiciousCharacters = @(
  [string][char]0x00C3,
  [string][char]0x00E2,
  [string][char]0xFFFD
)

foreach ($suspiciousCharacter in $suspiciousCharacters) {
  Assert-NoPatternMatches `
    -Paths @("README.md", "templates/*.md", "docs/example/*.md", "docs/example/adr/*.md", "docs/audit/*.md") `
    -Pattern ([regex]::Escape($suspiciousCharacter)) `
    -FailureMessage "Potential encoding corruption found in markdown content."
}
Add-CheckResult -Section "Content hygiene" -Check "Encoding drift" -Details "No suspicious mojibake characters found in README, templates, example, ADR, or audit docs"

Assert-RelativeMarkdownLinksExist -Path "README.md"
Assert-RelativeMarkdownLinksExist -Path "docs/example/README.md"
Assert-RelativeMarkdownLinksExist -Path "docs/example/assessment.md"
Assert-RelativeMarkdownLinksExist -Path "docs/example/12-assessment-playbook.md"
Assert-RelativeMarkdownLinksExist -Path "docs/example/13-post-decision-review.md"
Assert-RelativeMarkdownLinksExist -Path "docs/audit/master-mitigation-checklist.md"
Add-CheckResult -Section "References" -Check "Relative links" -Details "Verified markdown relative links in README, example package docs, trigger docs, and audit checklist"

$assessmentContent = Get-FileContent -Path "docs/example/assessment.md"
$adrContent = Get-FileContent -Path "docs/example/adr/ADR-001-incremental-modernization.md"
$exampleReadmeContent = Get-FileContent -Path "docs/example/README.md"
$traceabilityContent = Get-FileContent -Path "docs/example/09-traceability-matrix.md"
$evidenceContent = Get-FileContent -Path "docs/example/10-evidence-register.md"
$glossaryContent = Get-FileContent -Path "docs/example/11-glossary-and-conventions.md"
$roadmapContent = Get-FileContent -Path "docs/example/06-modernization-roadmap.md"
$decisionLogContent = Get-FileContent -Path "docs/example/07-decision-log.md"
$debtMapContent = Get-FileContent -Path "docs/example/08-technical-debt-map.md"
$playbookContent = Get-FileContent -Path "docs/example/12-assessment-playbook.md"
$postDecisionReviewContent = Get-FileContent -Path "docs/example/13-post-decision-review.md"

$assessmentRiskMatches = Get-Matches -Content $assessmentContent -Pattern '(?m)^\| (R\d+) \|'
$assessmentRiskIds = @($assessmentRiskMatches | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
if ($assessmentRiskIds.Count -eq 0) {
  throw "No risk IDs were found in docs/example/assessment.md"
}
Add-CheckResult -Section "Semantic traceability" -Check "Assessment risks" -Details ("Found risk IDs in example assessment: {0}" -f ($assessmentRiskIds -join ", "))

$adrRiskLineMatches = @(Get-Matches -Content $adrContent -Pattern '(?m)^- Related risks:\s*(.+)$')
if ($adrRiskLineMatches.Count -eq 0) {
  throw "ADR-001 is missing a related risks declaration."
}

$adrRiskIds = @()
foreach ($match in $adrRiskLineMatches) {
  $ids = [regex]::Matches($match.Groups[1].Value, 'R\d+')
  foreach ($id in $ids) {
    $adrRiskIds += $id.Value
  }
}
$adrRiskIds = @($adrRiskIds | Sort-Object -Unique)
if ($adrRiskIds.Count -eq 0) {
  throw "ADR-001 does not reference any risk IDs."
}
Add-CheckResult -Section "Semantic traceability" -Check "ADR related risks" -Details ("Found risk IDs in ADR: {0}" -f ($adrRiskIds -join ", "))

foreach ($assessmentRiskId in $assessmentRiskIds) {
  if ($adrRiskIds -notcontains $assessmentRiskId) {
    throw "Risk $assessmentRiskId exists in the example assessment but is not referenced by ADR-001."
  }
}
Add-CheckResult -Section "Semantic traceability" -Check "Assessment to ADR risk linkage" -Details "Every example risk ID is referenced by ADR-001"

Assert-Matches `
  -Content $assessmentContent `
  -Pattern 'Proceed incrementally under \[ADR-001\]\(adr/ADR-001-incremental-modernization\.md\)' `
  -FailureMessage "The example assessment does not link its decision section to ADR-001."
Add-CheckResult -Section "Semantic traceability" -Check "Decision linkage" -Details "The example assessment decision links directly to ADR-001"

$roadmapHorizons = @("Stabilize", "Isolate", "Extract")
foreach ($horizon in $roadmapHorizons) {
  Assert-Matches `
    -Content $assessmentContent `
    -Pattern ([regex]::Escape($horizon)) `
    -FailureMessage "The example assessment is missing the roadmap horizon: $horizon"
}
Add-CheckResult -Section "Semantic traceability" -Check "Roadmap horizons" -Details ("The example assessment includes roadmap horizons: {0}" -f ($roadmapHorizons -join ", "))

$traceabilityDriverMatches = Get-Matches -Content $traceabilityContent -Pattern '(?m)^\| (BD-\d{3}) \|'
$traceabilityDriverIds = @($traceabilityDriverMatches | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
if ($traceabilityDriverIds.Count -eq 0) {
  throw "No business driver IDs were found in docs/example/09-traceability-matrix.md"
}
Add-CheckResult -Section "Memory traceability" -Check "Business drivers" -Details ("Found driver IDs in traceability matrix: {0}" -f ($traceabilityDriverIds -join ", "))

$evidenceMatches = Get-Matches -Content $evidenceContent -Pattern '(?m)^\| (E-\d{3}) \|'
$evidenceIds = @($evidenceMatches | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
if ($evidenceIds.Count -eq 0) {
  throw "No evidence IDs were found in docs/example/10-evidence-register.md"
}
Add-CheckResult -Section "Memory traceability" -Check "Evidence register IDs" -Details ("Found evidence IDs: {0}" -f ($evidenceIds -join ", "))

$roadmapMatches = Get-Matches -Content $roadmapContent -Pattern '(?m)^\| (RM-\d{2}) \|'
$roadmapIds = @($roadmapMatches | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
if ($roadmapIds.Count -eq 0) {
  throw "No roadmap IDs were found in docs/example/06-modernization-roadmap.md"
}
Add-CheckResult -Section "Memory traceability" -Check "Roadmap IDs" -Details ("Found roadmap IDs: {0}" -f ($roadmapIds -join ", "))

$decisionMatches = Get-Matches -Content $decisionLogContent -Pattern '(?m)^\| (DEC-\d{3}) \|'
$decisionIds = @($decisionMatches | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
if ($decisionIds.Count -eq 0) {
  throw "No decision IDs were found in docs/example/07-decision-log.md"
}
Add-CheckResult -Section "Memory traceability" -Check "Decision IDs" -Details ("Found decision IDs: {0}" -f ($decisionIds -join ", "))

$debtMatches = Get-Matches -Content $debtMapContent -Pattern '(?m)^\| (TD-\d{3}) \|'
$debtIds = @($debtMatches | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
if ($debtIds.Count -eq 0) {
  throw "No debt IDs were found in docs/example/08-technical-debt-map.md"
}
Add-CheckResult -Section "Memory traceability" -Check "Debt IDs" -Details ("Found debt IDs: {0}" -f ($debtIds -join ", "))

Assert-Matches `
  -Content $exampleReadmeContent `
  -Pattern '09-traceability-matrix\.md' `
  -FailureMessage "The example package README does not include the traceability matrix."
Assert-Matches `
  -Content $exampleReadmeContent `
  -Pattern '10-evidence-register\.md' `
  -FailureMessage "The example package README does not include the evidence register."
Assert-Matches `
  -Content $exampleReadmeContent `
  -Pattern '11-glossary-and-conventions\.md' `
  -FailureMessage "The example package README does not include the glossary and conventions document."
Add-CheckResult -Section "Memory traceability" -Check "Package index coverage" -Details "The example package README indexes the traceability matrix, evidence register, and glossary"

foreach ($driverId in $traceabilityDriverIds) {
  if ($evidenceContent -notmatch [regex]::Escape($driverId)) {
    throw "Driver $driverId is present in the traceability matrix but missing from the evidence register."
  }
}
Add-CheckResult -Section "Memory traceability" -Check "Driver to evidence coverage" -Details "Every business driver in the traceability matrix appears in the evidence register"

foreach ($referencedEvidenceId in @(Get-Matches -Content $traceabilityContent -Pattern 'E-\d{3}' | ForEach-Object { $_.Value } | Sort-Object -Unique)) {
  if ($evidenceIds -notcontains $referencedEvidenceId) {
    throw "Evidence ID $referencedEvidenceId is referenced in the traceability matrix but missing from the evidence register."
  }
}
Add-CheckResult -Section "Memory traceability" -Check "Traceability evidence linkage" -Details "Every evidence ID referenced in the traceability matrix exists in the evidence register"

foreach ($referencedRoadmapId in @(Get-Matches -Content $traceabilityContent -Pattern 'RM-\d{2}' | ForEach-Object { $_.Value } | Sort-Object -Unique)) {
  if ($roadmapIds -notcontains $referencedRoadmapId) {
    throw "Roadmap ID $referencedRoadmapId is referenced in the traceability matrix but missing from the roadmap."
  }
}
Add-CheckResult -Section "Memory traceability" -Check "Traceability roadmap linkage" -Details "Every roadmap ID referenced in the traceability matrix exists in the roadmap"

foreach ($referencedDecisionId in @(Get-Matches -Content $traceabilityContent -Pattern 'DEC-\d{3}' | ForEach-Object { $_.Value } | Sort-Object -Unique)) {
  if ($decisionIds -notcontains $referencedDecisionId) {
    throw "Decision ID $referencedDecisionId is referenced in the traceability matrix but missing from the decision log."
  }
}
Add-CheckResult -Section "Memory traceability" -Check "Traceability decision linkage" -Details "Every decision ID referenced in the traceability matrix exists in the decision log"

foreach ($referencedDebtId in @(Get-Matches -Content $traceabilityContent -Pattern 'TD-\d{3}' | ForEach-Object { $_.Value } | Sort-Object -Unique)) {
  if ($debtIds -notcontains $referencedDebtId) {
    throw "Debt ID $referencedDebtId is referenced in the traceability matrix but missing from the debt map."
  }
}
Add-CheckResult -Section "Memory traceability" -Check "Traceability debt linkage" -Details "Every debt ID referenced in the traceability matrix exists in the debt map"

foreach ($referencedDriverId in @(Get-Matches -Content $evidenceContent -Pattern 'BD-\d{3}' | ForEach-Object { $_.Value } | Sort-Object -Unique)) {
  if ($traceabilityDriverIds -notcontains $referencedDriverId) {
    throw "Driver ID $referencedDriverId is referenced in the evidence register but missing from the traceability matrix."
  }
}
Add-CheckResult -Section "Memory traceability" -Check "Evidence driver linkage" -Details "Every driver ID referenced in the evidence register exists in the traceability matrix"

foreach ($referencedRiskId in @(Get-Matches -Content $evidenceContent -Pattern 'R\d+' | ForEach-Object { $_.Value } | Sort-Object -Unique)) {
  if ($assessmentRiskIds -notcontains $referencedRiskId) {
    throw "Risk ID $referencedRiskId is referenced in the evidence register but missing from the example assessment."
  }
}
Add-CheckResult -Section "Memory traceability" -Check "Evidence risk linkage" -Details "Every risk ID referenced in the evidence register exists in the example assessment"

Assert-Matches `
  -Content $glossaryContent `
  -Pattern 'BD-' `
  -FailureMessage "The glossary does not define the BD- identifier convention."
Assert-Matches `
  -Content $glossaryContent `
  -Pattern 'E-' `
  -FailureMessage "The glossary does not define the E- identifier convention."
Assert-Matches `
  -Content $glossaryContent `
  -Pattern 'RM-' `
  -FailureMessage "The glossary does not define the RM- identifier convention."
Assert-Matches `
  -Content $glossaryContent `
  -Pattern 'TD-' `
  -FailureMessage "The glossary does not define the TD- identifier convention."
Add-CheckResult -Section "Memory traceability" -Check "Glossary conventions" -Details "The glossary defines the core identifier prefixes used by the example package"

Assert-Matches `
  -Content $exampleReadmeContent `
  -Pattern '12-assessment-playbook\.md' `
  -FailureMessage "The example package README does not include the assessment playbook."
Assert-Matches `
  -Content $exampleReadmeContent `
  -Pattern '13-post-decision-review\.md' `
  -FailureMessage "The example package README does not include the post-decision review."
Add-CheckResult -Section "Trigger governance" -Check "Package index coverage" -Details "The example package README indexes the assessment playbook and post-decision review"

Assert-Matches `
  -Content $assessmentContent `
  -Pattern '12-assessment-playbook\.md' `
  -FailureMessage "The example assessment does not link to the assessment playbook."
Assert-Matches `
  -Content $assessmentContent `
  -Pattern '13-post-decision-review\.md' `
  -FailureMessage "The example assessment does not link to the post-decision review."
Add-CheckResult -Section "Trigger governance" -Check "Assessment trigger links" -Details "The executive assessment links to the playbook and post-decision review"

Assert-Matches `
  -Content $adrContent `
  -Pattern '## Follow-up signals' `
  -FailureMessage "ADR-001 does not declare follow-up signals."
Assert-Matches `
  -Content $adrContent `
  -Pattern 'RM-02' `
  -FailureMessage "ADR-001 follow-up signals do not reference RM-02."
Assert-Matches `
  -Content $adrContent `
  -Pattern 'RM-03' `
  -FailureMessage "ADR-001 follow-up signals do not reference RM-03."
Add-CheckResult -Section "Trigger governance" -Check "ADR follow-up signals" -Details "ADR-001 declares follow-up signals tied to RM-02 and RM-03"

Assert-Matches `
  -Content $playbookContent `
  -Pattern 'At least three evidence items are high confidence' `
  -FailureMessage "The example assessment playbook does not define a concrete minimum evidence threshold."
Assert-Matches `
  -Content $playbookContent `
  -Pattern 'Stop the assessment if carrier retry semantics remain unknown past 2026-08-22' `
  -FailureMessage "The example assessment playbook does not define a dated stop trigger."
Add-CheckResult -Section "Trigger governance" -Check "Playbook thresholds" -Details "The example playbook defines a concrete evidence threshold and a dated stop trigger"

Assert-Matches `
  -Content $playbookContent `
  -Pattern 'DEC-001' `
  -FailureMessage "The example playbook does not reference DEC-001."
Assert-Matches `
  -Content $playbookContent `
  -Pattern 'ADR-001' `
  -FailureMessage "The example playbook does not reference ADR-001."
Add-CheckResult -Section "Trigger governance" -Check "Playbook decision linkage" -Details "The example playbook links its triggers to DEC-001 and ADR-001"

Assert-Matches `
  -Content $postDecisionReviewContent `
  -Pattern 'Decision ID:\s*DEC-001' `
  -FailureMessage "The post-decision review does not reference DEC-001."
Assert-Matches `
  -Content $postDecisionReviewContent `
  -Pattern 'ADR-001' `
  -FailureMessage "The post-decision review does not reference ADR-001."
Assert-Matches `
  -Content $postDecisionReviewContent `
  -Pattern 'RM-02' `
  -FailureMessage "The post-decision review does not reference RM-02."
Add-CheckResult -Section "Trigger governance" -Check "Post-decision review linkage" -Details "The post-decision review links to DEC-001, ADR-001, and RM-02"

$followUpActionMatches = Get-Matches -Content $postDecisionReviewContent -Pattern '(?m)^\| [^|]+ \| [^|]+ \| \d{4}-\d{2}-\d{2} \| [^|]+ \|'
if ($followUpActionMatches.Count -lt 3) {
  throw "The post-decision review should contain at least three follow-up actions with due dates."
}
Add-CheckResult -Section "Trigger governance" -Check "Follow-up actions" -Details ("Found {0} dated follow-up actions in the post-decision review" -f $followUpActionMatches.Count)

Assert-Matches `
  -Content $decisionLogContent `
  -Pattern 'RM-02' `
  -FailureMessage "The decision log does not reference RM-02 in its review trigger."
Assert-Matches `
  -Content $decisionLogContent `
  -Pattern 'RM-03' `
  -FailureMessage "The decision log does not reference RM-03 in its review trigger."
Add-CheckResult -Section "Trigger governance" -Check "Decision log review triggers" -Details "The decision log includes explicit RM-02 and RM-03 review triggers"

Write-ValidationReport
