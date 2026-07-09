<#
.SYNOPSIS
    Lists every Pester test that is missing — or ambiguous on — a required tag axis.
.DESCRIPTION
    Inspects a discovery-only Pester result (Get-TestDiscovery), so EVERY test is checked regardless of run
    level or tag filters, and resolves each test's tier (L0-L3) and category (logic|integrity) via
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

    # The authoritative rule-id set, resolved once on the first well-formed citation and reused across tests
    # (Get-CatsAdrRuleIds is itself session-cached). Left $null until then so a run whose tests carry no
    # citation never reads the shipped ADR tree — keeping these logic tests hermetic. Registry (':') form.
    $validRuleIds = $null

    $violations = foreach ($test in $Discovery.Tests) {
        $reasons = @()

        $tierTags = Get-TestBlockTag -Test $test -Valid 'L0', 'L1', 'L2', 'L3'
        if ($tierTags.Count -ne 1) {
            $detail = if ($tierTags.Count) {
                ': ' + ($tierTags -join ',')
            }
            else {
                ''
            }
            $reasons += "tier resolves to $($tierTags.Count) (need exactly one of L0-L3)$detail"
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

        # Provenance axis (optional): collect every candidate citation — any tag carrying the reserved 'ADR-'
        # marker — across the block chain (own It-tags + ancestor blocks, root excluded), then classify each.
        # A malformed candidate never needs the rule-id set; a well-formed one triggers its lazy resolution.
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
                $reasons += "malformed ADR citation '$tag' (want ADR-<CODE>#<n>, e.g. ADR-AUTO-ERROR#3)"
                continue
            }
            if ($null -eq $validRuleIds) {
                $validRuleIds = [System.Collections.Generic.HashSet[string]]::new(
                    [string[]] (Get-CatsAdrRuleIds), [System.StringComparer]::Ordinal)
            }
            # Citations are '#' form; the rule-id set is registry ':' form (see docs/adr/index.md).
            if (-not $validRuleIds.Contains(($tag -replace '#', ':'))) {
                $reasons += "unknown ADR rule '$tag' — no such rule in docs/adr"
            }
        }

        if ($reasons) {
            [pscustomobject]@{
                Test   = $test.ExpandedName
                File   = $test.ScriptBlock.File
                Reason = $reasons -join '; '
            }
        }
    }

    , @($violations)
}
