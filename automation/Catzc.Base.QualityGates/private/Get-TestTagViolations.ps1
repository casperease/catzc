<#
.SYNOPSIS
    Lists every Pester test that is missing — or ambiguous on — a required tag axis.
.DESCRIPTION
    Inspects a discovery-only Pester result (Get-TestDiscovery), so EVERY test is checked regardless of run level or...
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

    # The authoritative rule-id set, resolved once on the first well-formed citation and reused across tests...
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

        # Provenance axis (optional): collect every candidate citation — any tag carrying the reserved 'ADR-' marker...
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
