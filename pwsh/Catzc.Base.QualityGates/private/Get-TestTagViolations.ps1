<#
---
catzc:
  immutable:
    with_body_sha: "43481ff2cd69"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1
    docs: "[Get-TestTagViolations.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-TestTagViolations.ps1.md)"
    cites:
      - ADR-PWSH-ERROR-THROWNOTWRITEERROR
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
    $form = (Get-Config -Config drs).CodeForm
    $citationTag = "^$($form.Kind)-"

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
            if ($tag -cmatch $citationTag) {
                [void]$candidates.Add($tag)
            }
        }
        $block = $test.Block
        while ($block -and -not $block.IsRoot) {
            foreach ($tag in $block.Tag) {
                if ($tag -cmatch $citationTag) {
                    [void]$candidates.Add($tag)
                }
            }
            $block = $block.Parent
        }
        foreach ($tag in $candidates) {
            if (-not $form.IsRule($tag)) {
                $reasons += "malformed ADR citation '$tag' (want a rule's code, e.g. ADR-PWSH-ERROR-THROWNOTWRITEERROR)"
                continue
            }
            if ($null -eq $validRuleIds) {
                $validRuleIds = [System.Collections.Generic.HashSet[string]]::new(
                    [string[]] (Get-CatsDrsRuleIds), [System.StringComparer]::Ordinal)
            }
            if (-not $validRuleIds.Contains($tag)) {
                $reasons += "unknown ADR rule '$tag' — no such rule in $((Get-Config -Config drs).Root)"
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
