<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1
    folder: private
    name: get-test-tag-violations
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Get-TestTagViolations.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1
    cites:
      - ADR-PWSH-ERROR#3
  config:
    synopsis: Lists every Pester test that is missing — or ambiguous on — a required tag axis.
    description: |-
      Inspects a discovery-only Pester result (Get-TestDiscovery), so EVERY test is checked regardless of run
      level or tag filters, and resolves each test's tier (L0-L4) and category (logic|integrity) via
      Get-TestBlockTag (nearest contributing block wins). A test is a violation when an axis resolves to zero
      tags (missing) or to more than one on its nearest contributing block (ambiguous).

      It also validates the optional provenance axis — the 'ADR-<CODE>#<n>' rule citations a test may carry to
      say which ADR rule(s) it enforces. Absence is never a violation (the axis is optional), but a PRESENT
      citation must be well-formed and resolve to a real rule: any tag carrying the reserved 'ADR-' marker that
      is not a well-formed 'ADR-<CODE>#<n>', or that names a rule absent from Get-CatsAdrRuleIds, is a violation.
      The rule-id set is resolved lazily (only when a well-formed citation is present), so tests with no
      citation stay hermetic — they never read the shipped ADR tree.

      Returns one object per violating test: @{ Test; File; Reason }. Test-Automation calls this to enforce that
      every test carries exactly one tier and one category tag, and that any rule citation it carries is real.
      See the test-automation ADR.
    parameters:
      Discovery: The discovery-only Pester run object (Get-TestDiscovery output) whose tests are inspected.
---
#>

function Get-TestTagViolations {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory)]
        $Discovery
    )

    $validRuleIds = $null

    $violations = foreach ($test in $Discovery.Tests) {
        $reasons = @()

        $tierTags = Get-TestBlockTag -Test $test -Valid ([Catzc.Base.Timeouts.TestTiers]::Names)
        if ($tierTags.Count -ne 1) {
            $detail = if ($tierTags.Count) {
                ': ' + ($tierTags -join ',')
            }
            else {
                ''
            }
            $reasons += "tier resolves to $($tierTags.Count) (need exactly one of $([Catzc.Base.Timeouts.TestTiers]::Names -join '|'))$detail"
        }

        $categoryTags = Get-TestBlockTag -Test $test -Valid 'logic', 'integrity'
        if ($categoryTags.Count -ne 1) {
            $detail = if ($categoryTags.Count) {
                ': ' + ($categoryTags -join ',')
            }
            else {
                ''
            }
            $reasons += "category resolves to $($categoryTags.Count) (need exactly one of logic|integrity)$detail"
        }

        $candidates = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($tag in $test.Tag) {
            if ($tag -like 'ADR-*') {
                [void]$candidates.Add($tag)
            }
        }
        $block = $test.Block
        while ($block -and -not $block.IsRoot) {
            foreach ($tag in $block.Tag) {
                if ($tag -like 'ADR-*') {
                    [void]$candidates.Add($tag)
                }
            }
            $block = $block.Parent
        }
        foreach ($tag in $candidates) {
            if ($tag -cnotmatch '^ADR-[A-Z]+(?:-[A-Z]+)*#\d+$') {
                $reasons += "malformed ADR citation '$tag' (want ADR-<CODE>#<n>, e.g. ADR-PWSH-ERROR#3)"
                continue
            }
            if ($null -eq $validRuleIds) {
                $validRuleIds = [System.Collections.Generic.HashSet[string]]::new(
                    [string[]] (Get-CatsAdrRuleIds), [System.StringComparer]::Ordinal)
            }
            # Citations are '#' form; the rule-id set is registry ':' form (see [index](/docs/adr/index.md)).
            if (-not $validRuleIds.Contains(($tag -replace '#', ':'))) {
                $reasons += "unknown ADR rule '$tag' — no such rule in docs/adr"
            }
        }

        if ($reasons) {
            [pscustomobject]@{
                Test   = $test.ExpandedName
                File   = Get-TestRunFile -Test $test
                Reason = $reasons -join '; '
            }
        }
    }

    , @($violations)
}
