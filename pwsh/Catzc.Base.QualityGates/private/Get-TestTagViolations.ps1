<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1
    folder: private
    name: get-test-tag-violations
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1
    docs: "[Get-TestTagViolations.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestTagViolations.ps1.md)"
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
            if ($tag -cnotmatch '^ADR(?:-[A-Z][A-Z0-9]*){3,}$') {
                $reasons += "malformed ADR citation '$tag' (want a rule's code, e.g. ADR-PWSH-ERROR-THROWNOTWRITEERROR)"
                continue
            }
            if ($null -eq $validRuleIds) {
                $validRuleIds = [System.Collections.Generic.HashSet[string]]::new(
                    [string[]] (Get-CatsAdrRuleIds), [System.StringComparer]::Ordinal)
            }
            if (-not $validRuleIds.Contains($tag)) {
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
