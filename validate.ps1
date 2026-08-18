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
  "docs/example/assessment.md",
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
    "| Stabilize |",
    "| Isolate |",
    "| Extract |",
    "| Optimize |"
  )
  "templates/07-decision-log.md" = @(
    "# Decision log"
  )
  "templates/08-technical-debt-map.md" = @(
    "# Technical debt map"
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
Assert-RelativeMarkdownLinksExist -Path "docs/example/assessment.md"
Assert-RelativeMarkdownLinksExist -Path "docs/audit/master-mitigation-checklist.md"
Add-CheckResult -Section "References" -Check "Relative links" -Details "Verified markdown relative links in README, example assessment, and audit checklist"

$assessmentContent = Get-FileContent -Path "docs/example/assessment.md"
$adrContent = Get-FileContent -Path "docs/example/adr/ADR-001-incremental-modernization.md"

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

Write-ValidationReport
