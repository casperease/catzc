<#
.SYNOPSIS
    Lists every Pester test that is missing — or ambiguous on — a required tag axis.
.DESCRIPTION
    A missing citation is never a violation, but a present one must be well-formed and name a real ADR rule.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestTagViolations.ps1.md#comment1)
.PARAMETER Discovery
    The discovery-only Pester run object (Get-TestDiscovery output) whose tests are inspected.
#>
function Get-TestTagViolations {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory)]
        $Discovery
    )

    # Left null until a well-formed citation shows up, so tests without one never read the shipped ADR tree.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-TestTagViolations.ps1.md#comment2)
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

        # A malformed candidate never needs the rule-id set; only a well-formed one triggers its lazy resolution.
        # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Get-TestTagViolations.ps1.md#comment3)
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
