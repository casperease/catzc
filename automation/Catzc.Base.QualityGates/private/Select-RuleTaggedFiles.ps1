<#
.SYNOPSIS
    The subset of test files that carry a test citing one of the given ADR rules — the -Rule work-list filter.
.DESCRIPTION
    Keeps whole files off the work-list; a file mixing matched and other tests is still filtered per test by the worker.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Select-RuleTaggedFiles.ps1.md#comment1)
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
        # The test's run file: its test file, or the Go test folder of a Go bridge test.
        $file = Get-TestRunFile -Test $test
        if (-not $file) {
            continue
        }
        foreach ($citation in (Get-TestRuleTags -Test $test)) {
            if ($ruleWanted.Contains($citation)) {
                [void]$ruleFiles.Add($file)
                break
            }
        }
    }

    @($TestFile | Where-Object { $ruleFiles.Contains($_) })
}
