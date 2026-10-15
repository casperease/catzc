<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-TEST#31
---
#>

<#
.SYNOPSIS
    Lists the tests a test run's opt-out tag removes from a run, so the exclusion is visible, never silent.
.DESCRIPTION
    A test already out by the tier or category filter is neither listed nor counted, so only real opt-outs show.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestOptOutExclusion.ps1.md#comment1)
.PARAMETER Discovery
    The run's discovery-only Pester result (Get-TestDiscovery).
.PARAMETER Tag
    The opt-out tag(s) — 'source-only' for the build run.
.PARAMETER ExcludeTag
    The run's tier/category exclude tags (Get-TestExcludeTag); tests resolving to one of them are out of scope.
.PARAMETER TestFiles
    The run's test files; tests outside them are ignored.
.OUTPUTS
    [pscustomobject] with Tests (rows of File, ExpandedPath, Level, Category, in discovery order),
    FullyExcludedFiles (files whose every in-scope test carries the tag), and RemainingFiles (-TestFiles without
    them, order kept).
#>
function Get-TestOptOutExclusion {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        $Discovery,

        [Parameter(Mandatory)]
        [string[]] $Tag,

        [AllowEmptyCollection()]
        [string[]] $ExcludeTag = @(),

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $TestFiles
    )

    $fileLookup = [System.Collections.Generic.HashSet[string]]::new([string[]] $TestFiles, [System.StringComparer]::OrdinalIgnoreCase)
    $excluded = [System.Collections.Generic.List[object]]::new()
    $excludedByFile = [ordered]@{}
    $runnableFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    # Never wrap the Get-TestBlockTag result in @(): that nests its single array object and every count reads 1.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-TestOptOutExclusion.ps1.md#comment2)
    foreach ($test in @($Discovery.Tests)) {
        # The test's run file: its test file, or the Go test folder of a Go bridge test.
        $file = Get-TestRunFile -Test $test
        if (-not $file -or -not $fileLookup.Contains($file)) {
            continue
        }

        # Out of the run's scope by tier or category: neither excluded by the opt-out tag nor runnable.
        if (-not (Test-TestInRunScope -Test $test -ExcludeTag $ExcludeTag)) {
            continue
        }
        $level = Get-TestBlockTag -Test $test -Valid ([Catzc.Base.Timeouts.TestTiers]::Names)
        $category = Get-TestBlockTag -Test $test -Valid 'logic', 'integrity'

        if ((Get-TestBlockTag -Test $test -Valid $Tag).Count -eq 0) {
            [void]$runnableFiles.Add($file)
            continue
        }

        $excluded.Add([pscustomobject]@{
                File         = $file
                ExpandedPath = $test.ExpandedPath
                Level        = $level -join ','
                Category     = $category -join ','
            })
        $excludedByFile[$file] = $true
    }

    $fullyExcluded = @($excludedByFile.Keys | Where-Object { -not $runnableFiles.Contains($_) })
    [pscustomobject]@{
        Tests              = @($excluded)
        FullyExcludedFiles = $fullyExcluded
        RemainingFiles     = @($TestFiles | Where-Object { $_ -notin $fullyExcluded })
    }
}
