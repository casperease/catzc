<#
.SYNOPSIS
    The subset of test files that carry a test citing one of the given ADR rules — the -Rule work-list filter.
.DESCRIPTION
    Test-Automation's `-Rule` provenance filter narrows the run to the files that actually enforce a rule.
    Given the discovery pass (all tests, any tier) and the wanted citations, this returns the files in
    which at least one test resolves one of those citations (Get-TestRuleTags, the same union used for
    coverage). The worker additionally filters within a file by include tag, so a file mixing matched and
    other tests runs only the matched ones; this just keeps whole non-matching files off the work-list.
.PARAMETER TestFile
    The candidate test files (absolute *.Tests.ps1 paths), in run order.
.PARAMETER Discovery
    The discovery-only Pester run object whose tests carry the citation tags.
.PARAMETER Rule
    The wanted citations in 'ADR-<CODE>#<n>' form. A file is kept when one of its tests cites any of them.
.OUTPUTS
    [string[]] the kept files, preserving the input order (empty when none match).
#>
function Select-RuleTaggedFiles {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $TestFile,

        [Parameter(Mandatory)]
        $Discovery,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Rule
    )

    $ruleWanted = [System.Collections.Generic.HashSet[string]]::new([string[]] $Rule, [System.StringComparer]::Ordinal)
    $ruleFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($test in @($Discovery.Tests)) {
        if (-not $test.ScriptBlock -or -not $test.ScriptBlock.File) {
            continue
        }
        foreach ($citation in (Get-TestRuleTags -Test $test)) {
            if ($ruleWanted.Contains($citation)) {
                [void]$ruleFiles.Add($test.ScriptBlock.File)
                break
            }
        }
    }

    , @($TestFile | Where-Object { $ruleFiles.Contains($_) })
}
